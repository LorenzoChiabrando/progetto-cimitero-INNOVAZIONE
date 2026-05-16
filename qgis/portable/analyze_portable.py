"""
analyze_portable.py — Portable GIS analysis (no PyQGIS / no QGIS Desktop).

Stessa logica di qgis/analyze_cementerio_general.py ma usa solo shapely +
pyproj + requests. Pensato per girare in un container Python slim e produrre
GeoJSON da caricare poi su Omeka S.

Output: cartella ./out/ con
  cementerio_general.geojson           (ingresso)
  cementerio_general_polygon.geojson   (bordo OSM)
  cementerio_general_buffers.geojson   (anelli 500/1000/2000 m)
  cementerio_general_poi_transport.geojson
  cementerio_general_poi_culture.geojson
  cementerio_general_poi_services.geojson
  cementerio_general_summary.json
"""

from __future__ import annotations

import json
import math
import os
import sys
import time
from dataclasses import dataclass
from datetime import datetime, timezone
from typing import Iterable

import requests
from shapely.geometry import Point, Polygon
from shapely.ops import transform
from pyproj import Transformer

# ---------------------------------------------------------------------------
# Configurazione
# ---------------------------------------------------------------------------

CEMETERY_NAME = "Cementerio General de Santiago"
# Ingresso pedonale principale: Prof. Alberto Zañartu 951, Recoleta.
# Coordinate triangolate da OSM (bus stop "Cementerio General / Prof. A. Zañartu"
# PB759 + tourism=information board sud-facing sul bordo del poligono).
CEMETERY_LAT = -33.4180
CEMETERY_LON = -70.6501
CEMETERY_ADDRESS = "Profesor Alberto Zañartu 951, Recoleta"
CEMETERY_FOUNDED = 1821
CEMETERY_DISTRICT = "Recoleta, Santiago, Chile"
CEMETERY_OSM_WAY_ID = 197839099

SEARCH_RADIUS_M = int(os.environ.get("SEARCH_RADIUS_M", "10000"))
BUFFER_RINGS_M = [500, 1000, 2000, 5000, 10000]
# Nessun POI interno al cimitero viene mantenuto: l'area è rappresentata solo
# dal poligono, i punti interni sarebbero tombe/monumenti del cimitero stesso.
ALLOW_INSIDE_CULTURE_SUBTYPES: set[str] = set()
THEME_CAP = int(os.environ.get("THEME_CAP", "80"))

OVERPASS_MIRRORS = [
    "https://overpass-api.de/api/interpreter",
    "https://overpass.kumi.systems/api/interpreter",
    "https://overpass.osm.ch/api/interpreter",
]
OVERPASS_TIMEOUT_S = 60

THEMES: dict[str, dict] = {
    "transport": {
        "label": "Public Transport",
        "color": "#1f6feb",
        "queries": [
            ("railway", ["station", "subway_entrance", "tram_stop"]),
            ("highway", ["bus_stop"]),
            ("amenity", ["bus_station", "taxi", "bicycle_rental"]),
            ("public_transport", ["station", "stop_position", "platform"]),
        ],
    },
    "culture": {
        "label": "Culture & Tourism",
        "color": "#b8860b",
        "queries": [
            ("tourism", ["museum", "gallery", "artwork", "attraction", "viewpoint", "information"]),
            ("historic", ["monument", "memorial", "church", "ruins", "archaeological_site", "heritage"]),
            ("amenity", ["theatre", "arts_centre", "library", "place_of_worship"]),
        ],
    },
    "services": {
        "label": "Visitor Services",
        "color": "#2f9e44",
        "queries": [
            ("amenity", ["cafe", "restaurant", "fast_food", "bar", "pub", "ice_cream",
                          "parking", "pharmacy", "atm", "toilets", "drinking_water"]),
            ("shop", ["florist", "convenience", "bakery", "gift", "souvenir"]),
            ("tourism", ["hotel", "hostel", "guest_house"]),
        ],
    },
}

# ---------------------------------------------------------------------------

def log(msg: str) -> None:
    print(f"[analyze] {msg}", flush=True)


def overpass_fetch(query: str) -> dict:
    last: Exception | None = None
    for url in OVERPASS_MIRRORS:
        for attempt in range(2):
            try:
                log(f"Overpass query → {url} (attempt {attempt + 1})")
                r = requests.post(url, data={"data": query}, timeout=OVERPASS_TIMEOUT_S + 10,
                                  headers={"User-Agent": "cementerio-portable/1.0"})
                r.raise_for_status()
                return r.json()
            except Exception as e:  # noqa: BLE001
                last = e
                time.sleep(2 + attempt * 3)
    raise RuntimeError(f"Tutti i mirror Overpass hanno fallito: {last}")


def fetch_cemetery_polygon(way_id: int) -> Polygon:
    q = f"[out:json][timeout:{OVERPASS_TIMEOUT_S}];way({way_id});out geom;"
    res = overpass_fetch(q)
    for el in res.get("elements", []):
        if el.get("type") == "way" and "geometry" in el:
            coords = [(p["lon"], p["lat"]) for p in el["geometry"]]
            if coords[0] != coords[-1]:
                coords.append(coords[0])
            return Polygon(coords)
    raise RuntimeError(f"Poligono cimitero non trovato (way {way_id})")


def build_overpass_query(lat: float, lon: float, radius_m: int) -> str:
    blocks: list[str] = []
    for theme in THEMES.values():
        for key, values in theme["queries"]:
            vre = "|".join(values)
            for el in ("node", "way", "relation"):
                blocks.append(f'{el}["{key}"~"^({vre})$"](around:{radius_m},{lat},{lon});')
    return (
        f"[out:json][timeout:{OVERPASS_TIMEOUT_S}];\n"
        f"(\n  " + "\n  ".join(blocks) + "\n);\n"
        "out center tags;"
    )


def classify(tags: dict) -> tuple[str | None, str | None]:
    for theme_key, theme in THEMES.items():
        for key, values in theme["queries"]:
            v = tags.get(key)
            if v in values:
                return theme_key, v
    return None, None


def haversine_m(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371000.0
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = math.radians(lat2 - lat1)
    dl = math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return 2 * R * math.asin(math.sqrt(a))


def ring_label(d: float) -> str:
    for r in BUFFER_RINGS_M:
        if d <= r:
            return f"<={r} m"
    return f">{BUFFER_RINGS_M[-1]} m"


def geodesic_buffer(lat: float, lon: float, radius_m: int) -> Polygon:
    """Buffer geodetico: WGS84 → UTM 19S (Santiago) → buffer in metri → WGS84."""
    to_utm = Transformer.from_crs("EPSG:4326", "EPSG:32719", always_xy=True).transform
    to_wgs = Transformer.from_crs("EPSG:32719", "EPSG:4326", always_xy=True).transform
    p = transform(to_utm, Point(lon, lat))
    return transform(to_wgs, p.buffer(radius_m, resolution=32))


def feature_collection(name: str, features: list[dict]) -> dict:
    return {
        "type": "FeatureCollection",
        "name": name,
        "crs": {"type": "name", "properties": {"name": "urn:ogc:def:crs:OGC:1.3:CRS84"}},
        "features": features,
    }


@dataclass
class Poi:
    osm_id: str
    name: str
    theme: str
    subtype: str
    lat: float
    lon: float
    distance_m: int
    ring: str

    def to_feature(self) -> dict:
        return {
            "type": "Feature",
            "properties": {
                "osm_id": self.osm_id, "name": self.name, "theme": self.theme,
                "subtype": self.subtype, "lat": self.lat, "lon": self.lon,
                "distance_m": self.distance_m, "ring": self.ring,
            },
            "geometry": {"type": "Point", "coordinates": [self.lon, self.lat]},
        }


def collect_pois(elements: Iterable[dict], polygon: Polygon) -> tuple[dict[str, list[Poi]], int]:
    themes_out: dict[str, list[Poi]] = {k: [] for k in THEMES}
    seen: set[tuple[str, int]] = set()
    inside_drops = 0

    for el in elements:
        eid = (el.get("type"), el.get("id"))
        if None in eid or eid in seen:
            continue
        seen.add(eid)

        tags = el.get("tags") or {}
        theme_key, sub = classify(tags)
        if not theme_key:
            continue

        if el["type"] == "node":
            lat, lon = el.get("lat"), el.get("lon")
        else:
            c = el.get("center") or {}
            lat, lon = c.get("lat"), c.get("lon")
        if lat is None or lon is None:
            continue

        if polygon.contains(Point(lon, lat)):
            if not (theme_key == "culture" and sub in ALLOW_INSIDE_CULTURE_SUBTYPES):
                inside_drops += 1
                continue

        name = (tags.get("name") or tags.get("name:es") or tags.get("name:en")
                or sub.replace("_", " ").title())
        d = int(round(haversine_m(CEMETERY_LAT, CEMETERY_LON, lat, lon)))
        themes_out[theme_key].append(
            Poi(osm_id=f"{el['type']}/{el['id']}", name=name, theme=theme_key,
                subtype=sub, lat=float(lat), lon=float(lon), distance_m=d,
                ring=ring_label(d))
        )

    # Dedup + sort + cap
    for k, lst in themes_out.items():
        seen_keys: set = set()
        deduped: list[Poi] = []
        for p in sorted(lst, key=lambda x: x.distance_m):
            key = (p.name.lower(), p.subtype, round(p.lat, 4), round(p.lon, 4))
            if key in seen_keys:
                continue
            seen_keys.add(key)
            deduped.append(p)
        themes_out[k] = deduped[:THEME_CAP]
    return themes_out, inside_drops


def write_outputs(out_dir: str, themes_out: dict[str, list[Poi]], polygon: Polygon,
                  inside_drops: int) -> dict[str, str]:
    os.makedirs(out_dir, exist_ok=True)
    files: dict[str, str] = {}

    def dump(path: str, payload: dict) -> None:
        with open(path, "w", encoding="utf-8") as f:
            json.dump(payload, f, ensure_ascii=False)

    # Entrance
    ent_fc = feature_collection("cementerio_general", [{
        "type": "Feature",
        "properties": {
            "name": CEMETERY_NAME, "district": CEMETERY_DISTRICT,
            "founded": CEMETERY_FOUNDED, "lat": CEMETERY_LAT, "lon": CEMETERY_LON,
            "kind": "main_pedestrian_entrance",
            "address": CEMETERY_ADDRESS,
            "label": f"Main pedestrian entrance ({CEMETERY_ADDRESS})",
        },
        "geometry": {"type": "Point", "coordinates": [CEMETERY_LON, CEMETERY_LAT]},
    }])
    files["cementerio_general.geojson"] = os.path.join(out_dir, "cementerio_general.geojson")
    dump(files["cementerio_general.geojson"], ent_fc)

    # Polygon
    poly_coords = [[round(x, 6), round(y, 6)] for x, y in polygon.exterior.coords]
    poly_fc = feature_collection("cementerio_general_polygon", [{
        "type": "Feature",
        "properties": {"osm_way_id": CEMETERY_OSM_WAY_ID,
                       "name": CEMETERY_NAME, "source": "OpenStreetMap"},
        "geometry": {"type": "Polygon", "coordinates": [poly_coords]},
    }])
    files["cementerio_general_polygon.geojson"] = os.path.join(out_dir, "cementerio_general_polygon.geojson")
    dump(files["cementerio_general_polygon.geojson"], poly_fc)

    # Buffers
    buffer_feats = []
    for r in BUFFER_RINGS_M:
        poly = geodesic_buffer(CEMETERY_LAT, CEMETERY_LON, r)
        coords = [[round(x, 6), round(y, 6)] for x, y in poly.exterior.coords]
        buffer_feats.append({
            "type": "Feature",
            "properties": {"ring_m": r, "label": f"{r} m"},
            "geometry": {"type": "Polygon", "coordinates": [coords]},
        })
    files["cementerio_general_buffers.geojson"] = os.path.join(out_dir, "cementerio_general_buffers.geojson")
    dump(files["cementerio_general_buffers.geojson"], feature_collection("buffers", buffer_feats))

    # POI per tema
    for key, pois in themes_out.items():
        path = os.path.join(out_dir, f"cementerio_general_poi_{key}.geojson")
        dump(path, feature_collection(f"poi_{key}", [p.to_feature() for p in pois]))
        files[f"cementerio_general_poi_{key}.geojson"] = path

    # Summary
    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "source": "OpenStreetMap via Overpass API (portable Python analysis)",
        "cemetery": {
            "name": CEMETERY_NAME, "district": CEMETERY_DISTRICT,
            "founded": CEMETERY_FOUNDED, "lat": CEMETERY_LAT, "lon": CEMETERY_LON,
            "address": CEMETERY_ADDRESS,
            "anchor": "main_pedestrian_entrance",
            "osm_polygon_id": f"way/{CEMETERY_OSM_WAY_ID}",
        },
        "search_radius_m": SEARCH_RADIUS_M,
        "buffer_rings_m": BUFFER_RINGS_M,
        "filtered_inside_polygon": inside_drops,
        "themes": {
            key: {
                "label": THEMES[key]["label"],
                "color": THEMES[key]["color"],
                "count": len(themes_out[key]),
                "highlights": [
                    {"name": p.name, "subtype": p.subtype,
                     "distance_m": p.distance_m, "ring": p.ring}
                    for p in themes_out[key][:10]
                ],
            }
            for key in THEMES
        },
    }
    files["cementerio_general_summary.json"] = os.path.join(out_dir, "cementerio_general_summary.json")
    with open(files["cementerio_general_summary.json"], "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    return files


def run(out_dir: str = "./out") -> dict[str, str]:
    log(f"Ingresso pedonale ({CEMETERY_ADDRESS}): {CEMETERY_LAT}, {CEMETERY_LON}")
    polygon = fetch_cemetery_polygon(CEMETERY_OSM_WAY_ID)
    log(f"Poligono OSM: {len(polygon.exterior.coords)} vertici, area {polygon.area:.6f}°²")

    query = build_overpass_query(CEMETERY_LAT, CEMETERY_LON, SEARCH_RADIUS_M)
    response = overpass_fetch(query)
    elements = response.get("elements", [])
    log(f"Overpass: {len(elements)} elementi grezzi")

    themes_out, inside_drops = collect_pois(elements, polygon)
    log(f"POI dentro al cimitero scartati: {inside_drops}")
    for key, pois in themes_out.items():
        log(f"  {key}: {len(pois)} POI")

    files = write_outputs(out_dir, themes_out, polygon, inside_drops)
    log(f"Output scritti in: {out_dir}")
    for name, path in files.items():
        log(f"  {name} ({os.path.getsize(path)} bytes)")
    return files


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "./out"
    run(out)
