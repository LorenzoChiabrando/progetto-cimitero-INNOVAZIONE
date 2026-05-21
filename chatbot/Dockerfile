FROM python:3.11-slim AS base

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /app

# Install runtime deps that scikit-learn needs (libgomp for OpenMP).
RUN apt-get update \
 && apt-get install -y --no-install-recommends libgomp1 curl \
 && rm -rf /var/lib/apt/lists/*

# Python deps cached in their own layer
COPY requirements.txt .
RUN pip install -r requirements.txt

# App source
COPY app/ ./app/

# Drop privileges
RUN useradd --system --uid 1001 chatbot \
 && chown -R chatbot:chatbot /app
USER chatbot

EXPOSE 8000

HEALTHCHECK --interval=15s --timeout=5s --retries=5 --start-period=20s \
    CMD curl -sf http://127.0.0.1:8000/health || exit 1

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
