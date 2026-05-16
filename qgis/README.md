# QGIS — Analisi geografica del Cementerio General

Analisi spaziale del **Cementerio General de Santiago** (Recoleta, Cile) integrata
nella demo. Due percorsi:

| Percorso | Dove gira | Quando usarlo |
|---|---|---|
| **A · Desktop PyQGIS** | QGIS Desktop ≥ 3.28 | Esplorazione interattiva, ispezione layer in QGIS |
| **B · Portable (Docker)** | Container `python:3.12-slim` | Bootstrap automatico in `docker compose up`, niente QGIS richiesto |

Entrambi producono **gli stessi GeoJSON** e la stessa logica di filtro point-in-polygon.

---

## Cosa producono entrambi gli script

1. **Ingresso principale** (★ in oro) del cimitero a `-33.4140, -70.6437`, lato Metro Cementerios (L2).
2. **Poligono reale** del cimitero da OSM (`way/197839099`).
3. **Anelli di prossimità** geodetici 500 m / 1 km / 2 km (proiezione UTM 19S → WGS84).
4. **POI da OpenStreetMap** via Overpass API, classificati in tre temi:
   - 🚌 Public Transport — metro, fermate bus, taxi, bike sharing
   - 🏛️ Culture & Tourism — musei, memoriali, monumenti, siti storici
   - ☕ Visitor Services — caffè, ristoranti, fioristi, parcheggi, hotel
5. **Filtro point-in-polygon**: scarta i POI dentro al cimitero (es. ristoranti taggati male).
   Eccezione: memoriali / monumenti / luoghi di culto interni vengono mantenuti (sono patrimonio).
6. **Distanze** dall'ingresso e anello di appartenenza per ogni POI.
7. Esporta 7 file: ingresso, poligono, anelli, 3 file POI tematici, summary JSON.

---

## A · Desktop PyQGIS

`analyze_cementerio_general.py` — usa solo PyQGIS + `urllib` (stdlib, niente pip).

```bash
# In QGIS: Plugins → Python Console
exec(open('/percorso/assoluto/qgis/analyze_cementerio_general.py').read())
```

Oppure: **Processing → Toolbox → Add Script to Toolbox…** e seleziona lo script.

Output in `qgis/output/`. Se trova `../cimitero-frontend/public/data/`, copia i file lì
in automatico (fallback per la pagina `/location`).

---

## B · Portable Docker (consigliato per la demo dockerizzata)

`portable/analyze_portable.py` + `portable/omeka_client.py` + `portable/bootstrap.py`
— versione no-QGIS che gira in un container Python slim, calcola gli stessi GeoJSON
e li **carica su Omeka S** come Item + Media.

### Build & run con docker compose

Il servizio `qgis-loader` è già nel `docker-compose.yml`. Al primo `docker compose up`:

1. Aspetta che Omeka sia `healthy`.
2. Esegue l'analisi (Overpass + shapely + pyproj).
3. Cerca un Item con `dcterms:identifier=cementerio_general_qgis_analysis`.
   - Esiste → aggiorna metadata e sostituisce tutte le Media.
   - Non esiste → crea l'Item e carica le Media.
4. Termina con `exit 0`.

```bash
docker compose -f docker-compose.production.yml up --build
# oppure, in dev (immagini gia' buildate):
docker compose up
```

### Triggerare manualmente (rerun)

```bash
docker compose run --rm qgis-loader
```

Idempotente: rilanciandolo l'Item esistente viene aggiornato, non duplicato.

### Variabili d'ambiente

| Variabile | Default | Descrizione |
|---|---|---|
| `OMEKA_INTERNAL_API_URL` | `http://omeka-app/api` | URL API Omeka raggiungibile dal container |
| `OMEKA_KEY_ID` | — | API key identity (configurata in compose) |
| `OMEKA_KEY_SECRET` | — | API key credential |
| `ITEM_IDENTIFIER` | `cementerio_general_qgis_analysis` | `dcterms:identifier` univoco per l'Item |
| `ITEM_TITLE` | `QGIS Analysis - Cementerio General` | Titolo dell'Item |
| `THEME_CAP` | `25` | Numero massimo di POI per tema |

### Test in locale (senza Docker)

```bash
cd qgis/portable
pip install -r requirements.txt
python analyze_portable.py /tmp/out    # solo analisi
OMEKA_KEY_ID=... OMEKA_KEY_SECRET=... \
  OMEKA_INTERNAL_API_URL=http://localhost:8080/api \
  python bootstrap.py                  # analisi + upload Omeka
```

---

## Come la pagina `/location` consuma i dati

Il frontend Next.js espone l'endpoint **`GET /api/gis`** (file
`cimitero-frontend/src/app/api/gis/route.ts`):

1. Cerca l'Item Omeka per `dcterms:identifier`.
2. Per ogni Media, scarica il contenuto GeoJSON.
3. Lo restituisce come unico payload alla pagina.
4. **Fallback automatico**: se l'Item non esiste o Omeka non è raggiungibile, legge
   i file da `public/data/` (utile in dev senza Docker).

La pagina mostra un badge **"via Omeka S"** o **"local fallback"** per debug.

---

## Output prodotti

| File | Contenuto |
|---|---|
| `cementerio_general.geojson` | Ingresso principale |
| `cementerio_general_polygon.geojson` | Bordo reale del cimitero (OSM way/197839099) |
| `cementerio_general_buffers.geojson` | Anelli 500 m / 1 km / 2 km |
| `cementerio_general_poi_transport.geojson` | POI trasporti |
| `cementerio_general_poi_culture.geojson` | POI cultura/turismo |
| `cementerio_general_poi_services.geojson` | POI servizi |
| `cementerio_general_summary.json` | Conteggi + top 10 per tema + n. POI scartati |

In Omeka S diventano la Media di un unico Item con metadata Dublin Core
(`dcterms:title`, `dcterms:description`, `dcterms:spatial`, ecc.).

---

## Personalizzazione

I parametri sono **gli stessi nei due script**. Tieni allineati:

```python
CEMETERY_LAT = -33.4140
CEMETERY_LON = -70.6437
CEMETERY_OSM_WAY_ID = 197839099
SEARCH_RADIUS_M = 1500
BUFFER_RINGS_M = [500, 1000, 2000]
ALLOW_INSIDE_CULTURE_SUBTYPES = {"memorial", "monument", "place_of_worship", "church"}
THEMES = { ... }
```

Per cambiare cimitero/città: aggiorna lat/lon, il `way_id` OSM del nuovo poligono e il raggio.

## Fonti dati

- POI e poligono cimitero: **OpenStreetMap** contributors — licenza ODbL.
- Proiezione metrica per buffer: **EPSG:32719** (UTM Zone 19S, copre Santiago).
- API: **Overpass** (`overpass-api.de` + 2 mirror per resilienza).
