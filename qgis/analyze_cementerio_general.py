"""
analyze_cementerio_general.py
=================================================
PyQGIS Processing script — Cementerio General, Santiago de Chile.

Esegui dentro QGIS (Processing Toolbox > Scripts > Add Script to Toolbox,
oppure dal Python Console: exec(open('analyze_cementerio_general.py').read())).

Cosa fa:
  1. Crea un layer puntuale con il centroide del Cementerio General (Recoleta).
  2. Scarica via Overpass API i POI nelle vicinanze divisi in 3 temi:
       - Trasporti pubblici (metro, bus, taxi)
       - Cultura & turismo (musei, monumenti, gallerie, siti storici)
       - Servizi al visitatore (caffe, ristoranti, fioristi, hotel, parcheggi)
  3. Calcola buffer di prossimita (500 m, 1 km, 2 km).
  4. Calcola la distanza di ciascun POI dal centroide del cimitero.
  5. Aggiunge tutti i layer al progetto QGIS con simbologia tematica.
  6. Esporta ogni layer come GeoJSON (EPSG:4326) e un summary JSON
     nella sottocartella ./output/ (creata accanto allo script).
  7. Opzionalmente copia i GeoJSON in cimitero-frontend/public/data/.

Lo script usa solo PyQGIS + urllib (standard library): nessuna dipendenza extra.
"""

from __future__ import annotations

import json
import math
import os
import shutil
import urllib.parse
import urllib.request
from datetime import datetime, timezone

from qgis.core import (
    QgsCoordinateReferenceSystem,
    QgsCoordinateTransform,
    QgsDistanceArea,
    QgsFeature,
    QgsField,
    QgsFields,
    QgsGeometry,
    QgsMarkerSymbol,
    QgsPointXY,
    QgsProject,
    QgsRuleBasedRenderer,
    QgsSingleSymbolRenderer,
    QgsSymbol,
    QgsVectorFileWriter,
    QgsVectorLayer,
    QgsWkbTypes,
)
from qgis.PyQt.QtCore import QVariant
from qgis.PyQt.QtGui import QColor

# ---------------------------------------------------------------------------
# Configurazione
# ---------------------------------------------------------------------------

CEMETERY_NAME = "Cementerio General de Santiago"
# Ingresso principale (lato est, di fronte alla stazione Metro Cementerios L2).
# Verificato su OSM contro way/197839099 (poligono del cimitero).
CEMETERY_LAT = -33.4140
CEMETERY_LON = -70.6437
CEMETERY_FOUNDED = 1821
CEMETERY_DISTRICT = "Recoleta, Santiago, Chile"

# OSM way id del poligono del cimitero. Usato per scaricare il bordo e filtrare
# i POI che cadono dentro al cimitero (es. ristoranti taggati erroneamente).
CEMETERY_OSM_WAY_ID = 197839099

# Raggio di ricerca POI in metri dall'ingresso. 1500 m copre Recoleta, parte di
# Bellavista e Cerro San Cristobal.
SEARCH_RADIUS_M = 1500

BUFFER_RINGS_M = [500, 1000, 2000]

# Sottotipi culturali ammessi anche se cadono dentro al cimitero (sono parte
# del patrimonio del cimitero stesso).
ALLOW_INSIDE_CULTURE_SUBTYPES = {"memorial", "monument", "place_of_worship", "church"}

OVERPASS_URL = "https://overpass-api.de/api/interpreter"
OVERPASS_TIMEOUT_S = 60

# Mappatura tematica: (tag chiave, valori) -> categoria demo.
# I valori provengono dalla tassonomia OpenStreetMap.
THEMES = {
    "transport": {
        "label": "Trasporti pubblici",
        "color": "#1f6feb",
        "queries": [
            ("railway", ["station", "subway_entrance", "tram_stop"]),
            ("highway", ["bus_stop"]),
            ("amenity", ["bus_station", "taxi", "bicycle_rental"]),
            ("public_transport", ["station", "stop_position", "platform"]),
        ],
    },
    "culture": {
        "label": "Cultura & turismo",
        "color": "#b8860b",
        "queries": [
            ("tourism", ["museum", "gallery", "artwork", "attraction", "viewpoint", "information"]),
            ("historic", ["monument", "memorial", "church", "ruins", "archaeological_site", "heritage"]),
            ("amenity", ["theatre", "arts_centre", "library", "place_of_worship"]),
        ],
    },
    "services": {
        "label": "Servizi al visitatore",
        "color": "#2f9e44",
        "queries": [
            ("amenity", ["cafe", "restaurant", "fast_food", "bar", "pub", "ice_cream", "parking", "pharmacy", "atm", "toilets", "drinking_water"]),
            ("shop", ["florist", "convenience", "bakery", "gift", "souvenir"]),
            ("tourism", ["hotel", "hostel", "guest_house"]),
        ],
    },
}

# ---------------------------------------------------------------------------
# Percorsi
# ---------------------------------------------------------------------------

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__)) if "__file__" in globals() else os.getcwd()
OUTPUT_DIR = os.path.join(SCRIPT_DIR, "output")
# Cartella public del frontend Next.js per la demo
FRONTEND_PUBLIC_DATA = os.path.normpath(
    os.path.join(SCRIPT_DIR, "..", "cimitero-frontend", "public", "data")
)

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def log(msg: str) -> None:
    print(f"[cementerio] {msg}")


def ensure_dir(path: str) -> None:
    if not os.path.isdir(path):
        os.makedirs(path, exist_ok=True)


def build_overpass_query(center_lat: float, center_lon: float, radius_m: int) -> str:
    """Costruisce una query Overpass QL che restituisce, per ogni POI tematico,
    nodi+ways+relations con il loro centroide gia' calcolato (out center).
    """
    blocks: list[str] = []
    for theme_key, theme in THEMES.items():
        for key, values in theme["queries"]:
            values_re = "|".join(values)
            for element in ("node", "way", "relation"):
                blocks.append(
                    f'{element}["{key}"~"^({values_re})$"](around:{radius_m},{center_lat},{center_lon});'
                )
    body = "\n  ".join(blocks)
    return (
        f"[out:json][timeout:{OVERPASS_TIMEOUT_S}];\n"
        f"(\n  {body}\n);\n"
        "out center tags;"
    )


OVERPASS_MIRRORS = [
    OVERPASS_URL,
    "https://overpass.kumi.systems/api/interpreter",
    "https://overpass.osm.ch/api/interpreter",
]


def overpass_fetch(query: str) -> dict:
    data = urllib.parse.urlencode({"data": query}).encode("utf-8")
    last_err: Exception | None = None
    for url in OVERPASS_MIRRORS:
        try:
            req = urllib.request.Request(
                url, data=data,
                headers={"User-Agent": "cementerio-general-demo/1.0 (PyQGIS)"},
            )
            log(f"Interrogo Overpass ({url})...")
            with urllib.request.urlopen(req, timeout=OVERPASS_TIMEOUT_S + 10) as resp:
                return json.loads(resp.read().decode("utf-8"))
        except Exception as e:
            last_err = e
            log(f"  mirror fallito: {e}; provo il prossimo...")
    raise RuntimeError(f"Tutti i mirror Overpass hanno fallito: {last_err}")


def fetch_cemetery_polygon(way_id: int) -> list[tuple[float, float]]:
    """Ritorna la lista di vertici (lon, lat) del poligono OSM del cimitero."""
    q = f"[out:json][timeout:{OVERPASS_TIMEOUT_S}];way({way_id});out geom;"
    res = overpass_fetch(q)
    for el in res.get("elements", []):
        if el.get("type") == "way" and "geometry" in el:
            return [(p["lon"], p["lat"]) for p in el["geometry"]]
    raise RuntimeError(f"Poligono cimitero non trovato (way {way_id})")


def point_in_ring(lon: float, lat: float, ring: list[tuple[float, float]]) -> bool:
    """Ray-casting point-in-polygon."""
    inside = False
    n = len(ring)
    j = n - 1
    for i in range(n):
        xi, yi = ring[i]
        xj, yj = ring[j]
        if ((yi > lat) != (yj > lat)) and (
            lon < (xj - xi) * (lat - yi) / (yj - yi + 1e-15) + xi
        ):
            inside = not inside
        j = i
    return inside


def classify_element(tags: dict) -> tuple[str | None, str | None]:
    """Restituisce (theme_key, subtype) per un elemento OSM, oppure (None, None)."""
    for theme_key, theme in THEMES.items():
        for key, values in theme["queries"]:
            value = tags.get(key)
            if value in values:
                return theme_key, value
    return None, None


def haversine_m(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371000.0
    phi1, phi2 = math.radians(lat1), math.radians(lat2)
    dphi = math.radians(lat2 - lat1)
    dlmb = math.radians(lon2 - lon1)
    a = math.sin(dphi / 2) ** 2 + math.cos(phi1) * math.cos(phi2) * math.sin(dlmb / 2) ** 2
    return 2 * R * math.asin(math.sqrt(a))

# ---------------------------------------------------------------------------
# Costruzione layer
# ---------------------------------------------------------------------------

def make_cemetery_layer() -> QgsVectorLayer:
    layer = QgsVectorLayer("Point?crs=EPSG:4326", "Cementerio General — ingresso principale", "memory")
    pr = layer.dataProvider()
    pr.addAttributes([
        QgsField("name", QVariant.String),
        QgsField("district", QVariant.String),
        QgsField("founded", QVariant.Int),
        QgsField("lat", QVariant.Double),
        QgsField("lon", QVariant.Double),
        QgsField("kind", QVariant.String),
    ])
    layer.updateFields()

    feat = QgsFeature(layer.fields())
    feat.setGeometry(QgsGeometry.fromPointXY(QgsPointXY(CEMETERY_LON, CEMETERY_LAT)))
    feat.setAttributes([CEMETERY_NAME, CEMETERY_DISTRICT, CEMETERY_FOUNDED,
                        CEMETERY_LAT, CEMETERY_LON, "main_entrance"])
    pr.addFeature(feat)
    layer.updateExtents()

    sym = QgsMarkerSymbol.createSimple({
        "name": "star",
        "color": "#d4af37",
        "outline_color": "#0a0a0a",
        "outline_width": "0.6",
        "size": "7",
    })
    layer.setRenderer(QgsSingleSymbolRenderer(sym))
    return layer


def make_polygon_layer(ring: list[tuple[float, float]]) -> QgsVectorLayer:
    """Layer poligonale con il bordo reale del cimitero (da OSM)."""
    layer = QgsVectorLayer("Polygon?crs=EPSG:4326",
                           f"Cementerio General — poligono OSM (way/{CEMETERY_OSM_WAY_ID})",
                           "memory")
    pr = layer.dataProvider()
    pr.addAttributes([QgsField("osm_way_id", QVariant.LongLong)])
    layer.updateFields()

    pts = [QgsPointXY(lon, lat) for lon, lat in ring]
    feat = QgsFeature(layer.fields())
    feat.setGeometry(QgsGeometry.fromPolygonXY([pts]))
    feat.setAttributes([CEMETERY_OSM_WAY_ID])
    pr.addFeature(feat)
    layer.updateExtents()

    sym = QgsSymbol.defaultSymbol(QgsWkbTypes.PolygonGeometry)
    sym.setColor(QColor(10, 10, 10, 25))
    layer.setRenderer(QgsSingleSymbolRenderer(sym))
    layer.setOpacity(0.85)
    return layer


def make_buffer_layer() -> QgsVectorLayer:
    """Anelli di buffer geodetici (metri) attorno al cimitero, riproiettati a 4326."""
    crs_wgs = QgsCoordinateReferenceSystem("EPSG:4326")
    # UTM 19S copre Santiago — proiezione metrica adatta per buffer accurati
    crs_utm = QgsCoordinateReferenceSystem("EPSG:32719")
    to_utm = QgsCoordinateTransform(crs_wgs, crs_utm, QgsProject.instance())
    to_wgs = QgsCoordinateTransform(crs_utm, crs_wgs, QgsProject.instance())

    center_wgs = QgsPointXY(CEMETERY_LON, CEMETERY_LAT)
    center_utm = to_utm.transform(center_wgs)

    layer = QgsVectorLayer("Polygon?crs=EPSG:4326", "Cementerio General — anelli di prossimita", "memory")
    pr = layer.dataProvider()
    pr.addAttributes([
        QgsField("ring_m", QVariant.Int),
        QgsField("label", QVariant.String),
    ])
    layer.updateFields()

    for radius in BUFFER_RINGS_M:
        geom_utm = QgsGeometry.fromPointXY(center_utm).buffer(radius, 64)
        geom_utm.transform(to_wgs)
        feat = QgsFeature(layer.fields())
        feat.setGeometry(geom_utm)
        feat.setAttributes([radius, f"{radius} m"])
        pr.addFeature(feat)
    layer.updateExtents()

    # Rule-based renderer: anelli concentrici in oro semi-trasparente
    sym = QgsSymbol.defaultSymbol(QgsWkbTypes.PolygonGeometry)
    sym.setColor(QColor(212, 175, 55, 35))
    layer.setRenderer(QgsSingleSymbolRenderer(sym))
    layer.setOpacity(0.55)
    return layer


def make_poi_layer(theme_key: str) -> QgsVectorLayer:
    theme = THEMES[theme_key]
    layer = QgsVectorLayer(
        "Point?crs=EPSG:4326",
        f"POI — {theme['label']}",
        "memory",
    )
    pr = layer.dataProvider()
    pr.addAttributes([
        QgsField("osm_id", QVariant.String),
        QgsField("name", QVariant.String),
        QgsField("theme", QVariant.String),
        QgsField("subtype", QVariant.String),
        QgsField("lat", QVariant.Double),
        QgsField("lon", QVariant.Double),
        QgsField("distance_m", QVariant.Int),
        QgsField("ring", QVariant.String),
    ])
    layer.updateFields()
    return layer


def style_poi_layer(layer: QgsVectorLayer, theme_key: str) -> None:
    theme = THEMES[theme_key]
    sym = QgsMarkerSymbol.createSimple({
        "name": "circle",
        "color": theme["color"],
        "outline_color": "#ffffff",
        "outline_width": "0.4",
        "size": "3",
    })
    layer.setRenderer(QgsSingleSymbolRenderer(sym))

# ---------------------------------------------------------------------------
# Esportazione
# ---------------------------------------------------------------------------

def export_geojson(layer: QgsVectorLayer, out_path: str) -> str:
    options = QgsVectorFileWriter.SaveVectorOptions()
    options.driverName = "GeoJSON"
    options.fileEncoding = "UTF-8"
    options.layerOptions = ["COORDINATE_PRECISION=6", "RFC7946=YES"]
    ctx = QgsProject.instance().transformContext()
    err, _, _, _ = QgsVectorFileWriter.writeAsVectorFormatV3(layer, out_path, ctx, options)
    if err != QgsVectorFileWriter.NoError:
        raise RuntimeError(f"Errore export GeoJSON ({out_path}): {err}")
    return out_path


def assign_ring(distance_m: float) -> str:
    for radius in BUFFER_RINGS_M:
        if distance_m <= radius:
            return f"<={radius} m"
    return f">{BUFFER_RINGS_M[-1]} m"

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def run() -> dict:
    ensure_dir(OUTPUT_DIR)
    project = QgsProject.instance()

    log(f"Ingresso principale: {CEMETERY_LAT}, {CEMETERY_LON} ({CEMETERY_NAME})")

    # 1) Ingresso del cimitero
    cemetery_layer = make_cemetery_layer()
    project.addMapLayer(cemetery_layer)

    # 2) Poligono reale del cimitero (da OSM) — usato anche per filtrare i POI interni
    polygon_ring = fetch_cemetery_polygon(CEMETERY_OSM_WAY_ID)
    log(f"Poligono OSM scaricato: {len(polygon_ring)} vertici")
    polygon_layer = make_polygon_layer(polygon_ring)
    project.addMapLayer(polygon_layer)

    # 3) Anelli di prossimita
    buffer_layer = make_buffer_layer()
    project.addMapLayer(buffer_layer)

    # 4) POI da Overpass
    query = build_overpass_query(CEMETERY_LAT, CEMETERY_LON, SEARCH_RADIUS_M)
    response = overpass_fetch(query)
    elements = response.get("elements", [])
    log(f"Overpass ha restituito {len(elements)} elementi.")

    poi_layers: dict[str, QgsVectorLayer] = {key: make_poi_layer(key) for key in THEMES}
    counters: dict[str, int] = {key: 0 for key in THEMES}
    seen_ids: set[tuple[str, int]] = set()
    summary_items: dict[str, list[dict]] = {key: [] for key in THEMES}
    inside_drops = 0

    for el in elements:
        el_type = el.get("type")
        el_id = el.get("id")
        if el_id is None or (el_type, el_id) in seen_ids:
            continue
        seen_ids.add((el_type, el_id))

        tags = el.get("tags", {}) or {}
        theme_key, subtype = classify_element(tags)
        if not theme_key:
            continue

        if el_type == "node":
            lat = el.get("lat")
            lon = el.get("lon")
        else:
            center = el.get("center") or {}
            lat = center.get("lat")
            lon = center.get("lon")
        if lat is None or lon is None:
            continue

        # Filtro: scarta i POI che cadono dentro al poligono del cimitero,
        # salvo memoriali/monumenti/luoghi di culto che ne fanno parte.
        if point_in_ring(lon, lat, polygon_ring):
            if not (theme_key == "culture" and subtype in ALLOW_INSIDE_CULTURE_SUBTYPES):
                inside_drops += 1
                continue

        distance = haversine_m(CEMETERY_LAT, CEMETERY_LON, lat, lon)
        name = tags.get("name") or tags.get("name:es") or tags.get("name:en") or subtype.replace("_", " ").title()
        ring = assign_ring(distance)

        layer = poi_layers[theme_key]
        feat = QgsFeature(layer.fields())
        feat.setGeometry(QgsGeometry.fromPointXY(QgsPointXY(lon, lat)))
        feat.setAttributes([
            f"{el_type}/{el_id}",
            name,
            theme_key,
            subtype,
            float(lat),
            float(lon),
            int(round(distance)),
            ring,
        ])
        layer.dataProvider().addFeature(feat)
        counters[theme_key] += 1
        summary_items[theme_key].append({
            "osm_id": f"{el_type}/{el_id}",
            "name": name,
            "subtype": subtype,
            "lat": lat,
            "lon": lon,
            "distance_m": int(round(distance)),
            "ring": ring,
        })

    log(f"POI scartati perché interni al poligono del cimitero: {inside_drops}")
    for key, layer in poi_layers.items():
        layer.updateExtents()
        style_poi_layer(layer, key)
        project.addMapLayer(layer)
        log(f"  - {THEMES[key]['label']}: {counters[key]} POI")

    # 5) Export GeoJSON
    exports: dict[str, str] = {}
    exports["cementerio"] = export_geojson(cemetery_layer, os.path.join(OUTPUT_DIR, "cementerio_general.geojson"))
    exports["polygon"] = export_geojson(polygon_layer, os.path.join(OUTPUT_DIR, "cementerio_general_polygon.geojson"))
    exports["buffers"] = export_geojson(buffer_layer, os.path.join(OUTPUT_DIR, "cementerio_general_buffers.geojson"))
    for key, layer in poi_layers.items():
        exports[key] = export_geojson(layer, os.path.join(OUTPUT_DIR, f"cementerio_general_poi_{key}.geojson"))

    # 6) Summary leggibile (ordinato per distanza, top 10 per tema)
    for key in summary_items:
        summary_items[key].sort(key=lambda x: x["distance_m"])

    summary = {
        "generated_at": datetime.now(timezone.utc).isoformat(),
        "cemetery": {
            "name": CEMETERY_NAME,
            "district": CEMETERY_DISTRICT,
            "founded": CEMETERY_FOUNDED,
            "lat": CEMETERY_LAT,
            "lon": CEMETERY_LON,
            "anchor": "main_entrance",
            "osm_polygon_id": f"way/{CEMETERY_OSM_WAY_ID}",
        },
        "search_radius_m": SEARCH_RADIUS_M,
        "buffer_rings_m": BUFFER_RINGS_M,
        "filtered_inside_polygon": inside_drops,
        "themes": {
            key: {
                "label": THEMES[key]["label"],
                "color": THEMES[key]["color"],
                "count": counters[key],
                "highlights": summary_items[key][:10],
            }
            for key in THEMES
        },
    }
    summary_path = os.path.join(OUTPUT_DIR, "cementerio_general_summary.json")
    with open(summary_path, "w", encoding="utf-8") as f:
        json.dump(summary, f, ensure_ascii=False, indent=2)
    exports["summary"] = summary_path

    # 6) Copia nel frontend (se presente)
    if os.path.isdir(os.path.dirname(FRONTEND_PUBLIC_DATA)):
        ensure_dir(FRONTEND_PUBLIC_DATA)
        for src in exports.values():
            dst = os.path.join(FRONTEND_PUBLIC_DATA, os.path.basename(src))
            shutil.copyfile(src, dst)
        log(f"Output copiato in: {FRONTEND_PUBLIC_DATA}")
    else:
        log("Cartella frontend non trovata: skip copia in public/.")

    # 7) Zoom al cimitero
    canvas_iface = globals().get("iface")
    if canvas_iface is not None:
        canvas_iface.setActiveLayer(cemetery_layer)
        canvas_iface.zoomToActiveLayer()
        canvas_iface.mapCanvas().zoomScale(20000)

    log("Fatto. Output:")
    for name, path in exports.items():
        log(f"  {name}: {path}")
    return summary


if __name__ == "__main__" or "qgis" in globals():
    run()
