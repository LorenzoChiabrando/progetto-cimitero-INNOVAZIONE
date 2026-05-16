# qgis-loader: container one-shot che esegue l'analisi GIS portable
# e carica i risultati su Omeka S.
FROM python:3.12-slim

# libgeos e proj sono necessari per shapely + pyproj
RUN apt-get update && apt-get install -y --no-install-recommends \
      libgeos-c1v5 \
      proj-bin \
      proj-data \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY analyze_portable.py omeka_client.py bootstrap.py ./

ENV PYTHONUNBUFFERED=1
ENV OMEKA_INTERNAL_API_URL=http://omeka-app/api

ENTRYPOINT ["python", "/app/bootstrap.py"]
