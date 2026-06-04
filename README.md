# Cementerio General — Digital Heritage Platform

A web platform for the cultural valorisation of the **Cementerio General de Santiago** (Recoleta, Chile), built for the *Innovazione Digitale* course. It turns the tangible and intangible heritage of the cemetery into a navigable digital experience: a structured archive, an interactive plan of the grounds, a geographic analysis of the surroundings, 3D models, speech synthesis, and a conversational assistant.

The project is delivered as a set of containerised services orchestrated with Docker Compose.

## Architecture

The system is composed of five cooperating services:

| Service | Role | Port |
|---|---|---|
| `db` | MySQL 8, persistence for the Omeka catalogue | 3306 |
| `omeka-app` | Omeka S, headless CMS exposing the archive through its REST API | 8080 |
| `frontend` | Next.js 16 application, the public site and dashboards | 3000 |
| `chatbot` | FastAPI service answering site and cemetery FAQs | 8000 (internal) |
| `phpmyadmin` | Web GUI for database inspection and dumps | 8081 |

The frontend never talks to MySQL directly. It reads the catalogue from the Omeka S API over the internal network and proxies the chatbot through its own API routes.

## Components

### Frontend (`cimitero-frontend/`)

Next.js 16 with the App Router, React 19, TypeScript and Tailwind CSS 4. The main routes are:

| Route | Purpose |
|---|---|
| `/` | Home and entry point to the four main areas |
| `/archive`, `/archive/[id]` | Digital archive: listing, search, and item detail with media gallery, author and date, 3D models and text to speech |
| `/map` | Interactive SVG plan of the cemetery, areas linked to their items |
| `/location` | GIS view with the real boundary, proximity rings and nearby points of interest |
| `/about` | Project context, data sources and credits |
| `/login`, `/dashboard` | Demo roles and the personal or curatorial dashboard |

Authentication and authorship are handled client side for the demo, with an *archivist* role that manages the catalogue and a *researcher* role with favourites, notes and visit history. The text to speech and chatbot integrations are served through `src/app/api`.

### Catalogue (Omeka S)

Omeka S acts as the headless content backend. Items are described with Dublin Core metadata and grouped into thematic collections such as *Historical Figures* and *Funeral Architecture*. The seed data lives in `omeka_s-7.sql`, uploaded media in `omeka-files/`. The custom **ThreeDViewer** module (`omeka-modules/ThreeDViewer/`) renders GLB models on the media page.

### Chatbot (`chatbot/`)

A FastAPI service performing TF-IDF retrieval over a curated knowledge base (`app/knowledge.json`). It runs fully offline with no external API dependency and exposes a `/health` endpoint used by the compose healthcheck.

### Geospatial analysis (`qgis/`)

Two interchangeable paths producing the same GeoJSON output:

1. **Desktop PyQGIS** (`analyze_cementerio_general.py`), run from the QGIS Python console.
2. **Portable** (`qgis/portable/`), a Docker based variant requiring no QGIS install.

Both derive the cemetery polygon from OpenStreetMap, compute geodesic proximity rings (500 m, 1 km, 2 km), and classify nearby points of interest into transport, culture and visitor services through Overpass, filtering out points that fall inside the cemetery. Results are consumed by the `/location` page.

## Running the demo

Requirements: Docker and Docker Compose.

```bash
docker compose up
```

Then open:

- Public site: http://localhost:3000
- Omeka S admin: http://localhost:8080
- phpMyAdmin: http://localhost:8081 (server `db`, user `root`, password `rootpassword`)

The frontend waits for Omeka and the chatbot to report healthy before starting. The database is seeded from the bundled SQL dump on first boot and persists in the `db_data` volume.

### Production

`docker-compose.production.yml` together with the `Dockerfile.*.production` files builds the published images. A Cloudflare tunnel script (`scripts/demo-tunnel.sh`) exposes the demo over a public URL.

## Repository layout

```
cimitero-frontend/      Next.js application
chatbot/                FastAPI TF-IDF assistant
omeka-modules/          Custom Omeka S modules (ThreeDViewer)
omeka-files/            Uploaded media for the catalogue
qgis/                   Geospatial analysis (desktop and portable)
scripts/                Operational scripts (Cloudflare tunnel)
docs/                   Extended documentation
docker-compose.yml      Local orchestration
omeka_s-7.sql           Database seed
```
