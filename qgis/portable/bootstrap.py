"""
bootstrap.py — Entry del container qgis-loader.

Flusso:
  1. Aspetta che Omeka S risponda all'API.
  2. Esegue analyze_portable.run() per generare i GeoJSON in /tmp/out/.
  3. Cerca un Item Omeka con dcterms:identifier=ITEM_IDENTIFIER.
     - Se esiste: aggiorna metadata e sostituisce le Media.
     - Se no: crea un nuovo Item.
  4. Logga URL della pagina dell'Item su Omeka.

Variabili ambiente:
  OMEKA_INTERNAL_API_URL  (default http://omeka-app/api)
  OMEKA_KEY_ID            (obbligatoria)
  OMEKA_KEY_SECRET        (obbligatoria)
  ITEM_IDENTIFIER         (default 'cementerio_general_qgis_analysis')
  ITEM_TITLE              (default 'QGIS Analysis - Cementerio General')
  RUN_ONCE                ('1' per uscire dopo l'upload, default '1')
"""

from __future__ import annotations

import os
import sys
import traceback

import analyze_portable
import omeka_client


OUT_DIR = "/tmp/out"

ITEM_IDENTIFIER = os.environ.get("ITEM_IDENTIFIER", "cementerio_general_qgis_analysis")
ITEM_TITLE = os.environ.get("ITEM_TITLE", "QGIS Analysis - Cementerio General")
ITEM_DESCRIPTION = (
    "Spatial analysis of Cementerio General de Santiago (Recoleta, Chile): main entrance, "
    "OSM boundary polygon, 500/1000/2000 m proximity rings and OpenStreetMap POIs grouped "
    "by Public Transport, Culture & Tourism and Visitor Services. Points inside the cemetery "
    "polygon are filtered out except for legitimate memorials and monuments."
)


def build_item_payload(client: omeka_client.OmekaClient) -> dict:
    """Costruisce il payload Omeka S per Item con metadata Dublin Core."""
    return {
        "@type": ["o:Item"],
        "dcterms:identifier": [client.literal("dcterms:identifier", ITEM_IDENTIFIER)],
        "dcterms:title": [client.literal("dcterms:title", ITEM_TITLE)],
        "dcterms:description": [client.literal("dcterms:description", ITEM_DESCRIPTION)],
        "dcterms:type": [client.literal("dcterms:type", "Dataset")],
        "dcterms:format": [client.literal("dcterms:format", "application/geo+json")],
        "dcterms:source": [client.literal(
            "dcterms:source",
            "OpenStreetMap via Overpass API, way/197839099 (cemetery polygon)"
        )],
        "dcterms:spatial": [client.literal(
            "dcterms:spatial",
            f"{analyze_portable.CEMETERY_LAT},{analyze_portable.CEMETERY_LON}"
        )],
        "dcterms:coverage": [client.literal("dcterms:coverage", analyze_portable.CEMETERY_DISTRICT)],
        "dcterms:creator": [client.literal("dcterms:creator", "qgis-loader (portable Python)")],
    }


# Mappa nome file -> titolo human-readable per la Media
FILE_TITLES = {
    "cementerio_general.geojson":                "Main entrance (point)",
    "cementerio_general_polygon.geojson":        "Cemetery boundary (OSM polygon)",
    "cementerio_general_buffers.geojson":        "Proximity rings 500/1000/2000 m",
    "cementerio_general_poi_transport.geojson":  "POIs - Public Transport",
    "cementerio_general_poi_culture.geojson":    "POIs - Culture & Tourism",
    "cementerio_general_poi_services.geojson":   "POIs - Visitor Services",
    "cementerio_general_summary.json":           "Analysis summary",
}


def main() -> int:
    print("[bootstrap] avvio qgis-loader", flush=True)
    try:
        client = omeka_client.from_env()
    except Exception as e:  # noqa: BLE001
        print(f"[bootstrap] errore di configurazione: {e}", file=sys.stderr, flush=True)
        return 2

    print(f"[bootstrap] Omeka API: {client.cfg.base_url}", flush=True)
    client.wait_until_ready()

    # 1) Analisi
    files = analyze_portable.run(OUT_DIR)

    # 2) Upsert Item
    payload = build_item_payload(client)
    existing = client.find_item_by_identifier(ITEM_IDENTIFIER)
    if existing:
        item_id = existing["o:id"]
        print(f"[bootstrap] Item esistente trovato (id={item_id}), aggiorno...", flush=True)
        item = client.update_item(item_id, payload)
    else:
        print("[bootstrap] Item non esiste, creo...", flush=True)
        item = client.create_item(payload)
        item_id = item["o:id"]
    print(f"[bootstrap] Item id={item_id}", flush=True)

    # 3) Carica Media
    files_with_titles: list[tuple[str, str]] = []
    for fname, path in files.items():
        title = FILE_TITLES.get(fname, fname)
        files_with_titles.append((path, title))
    client.replace_media(item_id, files_with_titles)

    public_url = client.cfg.base_url.rsplit("/api", 1)[0] + f"/admin/item/{item_id}"
    print(f"[bootstrap] OK. Item su Omeka: {public_url}", flush=True)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:  # noqa: BLE001
        traceback.print_exc()
        sys.exit(1)
