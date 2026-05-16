"""
omeka_client.py — Client minimale per Omeka S REST API.

Funzionalita supportate:
  - lookup property ID da term (es. "dcterms:title")
  - find_item_by_identifier(): cerca Item per dcterms:identifier (idempotenza)
  - upsert_item(): crea o aggiorna l'Item con proprieta Dublin Core
  - replace_media(): elimina le Media correnti dell'Item e ricarica nuove file
"""

from __future__ import annotations

import json
import mimetypes
import os
import time
from dataclasses import dataclass
from typing import Any

import requests


@dataclass
class OmekaConfig:
    base_url: str           # es. http://omeka-app/api
    key_identity: str
    key_credential: str
    timeout_s: int = 30

    @property
    def auth_params(self) -> dict[str, str]:
        return {"key_identity": self.key_identity, "key_credential": self.key_credential}


class OmekaClient:
    def __init__(self, cfg: OmekaConfig) -> None:
        self.cfg = cfg
        self._prop_cache: dict[str, int] = {}

    # ---------- utilities ----------

    def _log(self, msg: str) -> None:
        print(f"[omeka] {msg}", flush=True)

    def _get(self, path: str, params: dict | None = None) -> Any:
        p = dict(self.cfg.auth_params)
        if params:
            p.update(params)
        r = requests.get(f"{self.cfg.base_url}{path}", params=p, timeout=self.cfg.timeout_s)
        r.raise_for_status()
        return r.json()

    def _post(self, path: str, payload: dict) -> Any:
        r = requests.post(
            f"{self.cfg.base_url}{path}",
            params=self.cfg.auth_params,
            json=payload,
            timeout=self.cfg.timeout_s,
        )
        if not r.ok:
            self._log(f"POST {path} failed: {r.status_code} {r.text[:400]}")
            r.raise_for_status()
        return r.json()

    def _patch(self, path: str, payload: dict) -> Any:
        r = requests.patch(
            f"{self.cfg.base_url}{path}",
            params=self.cfg.auth_params,
            json=payload,
            timeout=self.cfg.timeout_s,
        )
        if not r.ok:
            self._log(f"PATCH {path} failed: {r.status_code} {r.text[:400]}")
            r.raise_for_status()
        return r.json()

    def _delete(self, path: str) -> None:
        r = requests.delete(f"{self.cfg.base_url}{path}", params=self.cfg.auth_params,
                            timeout=self.cfg.timeout_s)
        if r.status_code in (200, 204):
            return
        # Omeka S a volte risponde 500 dopo aver gia' cancellato la risorsa:
        # nel rendering della risposta tenta di serializzare l'entita' appena
        # eliminata e Doctrine fallisce con ORMInvalidArgumentException.
        # Verifichiamo con un GET: se la risorsa e' 404 la delete e' andata.
        if r.status_code == 500:
            probe = requests.get(f"{self.cfg.base_url}{path}", params=self.cfg.auth_params,
                                 timeout=self.cfg.timeout_s)
            if probe.status_code == 404:
                self._log(f"DELETE {path}: 500 ma risorsa gia' cancellata (verificato con GET 404), proseguo")
                return
        self._log(f"DELETE {path} failed: {r.status_code} {r.text[:200]}")
        r.raise_for_status()

    def wait_until_ready(self, max_attempts: int = 60, delay_s: float = 2.0) -> None:
        """Polla /api/items finché Omeka non risponde 200."""
        last_err: Exception | None = None
        for i in range(max_attempts):
            try:
                r = requests.get(f"{self.cfg.base_url}/items", params={**self.cfg.auth_params, "per_page": 1},
                                 timeout=self.cfg.timeout_s)
                if r.ok:
                    self._log(f"Omeka raggiungibile dopo {i + 1} tentativi.")
                    return
                last_err = RuntimeError(f"HTTP {r.status_code}: {r.text[:200]}")
            except Exception as e:  # noqa: BLE001
                last_err = e
            time.sleep(delay_s)
        raise RuntimeError(f"Omeka non e' diventato pronto entro {max_attempts * delay_s:.0f}s: {last_err}")

    # ---------- properties ----------

    def property_id(self, term: str) -> int:
        """Risolve un termine 'vocab:local' al suo property id Omeka."""
        if term in self._prop_cache:
            return self._prop_cache[term]
        vocab, local = term.split(":")
        results = self._get("/properties", {"vocabulary_prefix": vocab, "local_name": local, "per_page": 1})
        if not results:
            raise RuntimeError(f"Property non trovata: {term}")
        pid = int(results[0]["o:id"])
        self._prop_cache[term] = pid
        return pid

    def literal(self, term: str, value: str) -> dict:
        return {
            "type": "literal",
            "property_id": self.property_id(term),
            "@value": value,
        }

    # ---------- items ----------

    def find_item_by_identifier(self, identifier: str) -> dict | None:
        """Cerca un Item con dcterms:identifier == identifier (exact match)."""
        pid = self.property_id("dcterms:identifier")
        params = {
            "property[0][property]": pid,
            "property[0][type]": "eq",
            "property[0][text]": identifier,
            "per_page": 1,
        }
        results = self._get("/items", params)
        return results[0] if results else None

    def create_item(self, payload: dict) -> dict:
        return self._post("/items", payload)

    def update_item(self, item_id: int | str, payload: dict) -> dict:
        return self._patch(f"/items/{item_id}", payload)

    # ---------- media ----------

    def list_media_for_item(self, item_id: int | str) -> list[dict]:
        return self._get("/media", {"item_id": item_id, "per_page": 200})

    def delete_media(self, media_id: int | str) -> None:
        self._delete(f"/media/{media_id}")

    def upload_media(self, item_id: int | str, file_path: str,
                     title: str, properties: list[dict] | None = None) -> dict:
        """Carica un file come Media collegato a item_id (ingester=upload)."""
        mime, _ = mimetypes.guess_type(file_path)
        if file_path.endswith(".geojson"):
            mime = "application/geo+json"
        elif file_path.endswith(".json"):
            mime = "application/json"
        mime = mime or "application/octet-stream"

        data_obj = {
            "o:ingester": "upload",
            "file_index": "0",
            "o:item": {"o:id": int(item_id)},
            "o:source": os.path.basename(file_path),
            "dcterms:title": [self.literal("dcterms:title", title)],
        }
        if properties:
            for p in properties:
                key = next((k for k in p if k.startswith("dcterms:") or ":" in k), None)
                if key is None:
                    continue
                data_obj.setdefault(key, []).extend(p[key])

        with open(file_path, "rb") as f:
            files = {
                "data": (None, json.dumps(data_obj), "application/json"),
                "file[0]": (os.path.basename(file_path), f, mime),
            }
            r = requests.post(
                f"{self.cfg.base_url}/media",
                params=self.cfg.auth_params,
                files=files,
                timeout=self.cfg.timeout_s * 2,
            )
        if not r.ok:
            self._log(f"upload_media failed for {file_path}: {r.status_code} {r.text[:400]}")
            r.raise_for_status()
        return r.json()

    def replace_media(self, item_id: int | str, files_with_titles: list[tuple[str, str]]) -> list[dict]:
        """Cancella tutta la Media corrente dell'Item e ricarica la nuova."""
        for m in self.list_media_for_item(item_id):
            mid = m.get("o:id")
            if mid is not None:
                self.delete_media(mid)
                self._log(f"  - deleted media {mid}")
        out: list[dict] = []
        for path, title in files_with_titles:
            res = self.upload_media(item_id, path, title)
            out.append(res)
            self._log(f"  + uploaded {os.path.basename(path)} -> media {res.get('o:id')}")
        return out


def from_env() -> OmekaClient:
    base = (os.environ.get("OMEKA_API_URL")
            or os.environ.get("OMEKA_INTERNAL_API_URL")
            or "http://omeka-app/api").rstrip("/")
    kid = os.environ.get("OMEKA_KEY_ID", "")
    ksec = os.environ.get("OMEKA_KEY_SECRET", "")
    if not (kid and ksec):
        raise RuntimeError("OMEKA_KEY_ID e OMEKA_KEY_SECRET devono essere impostate")
    return OmekaClient(OmekaConfig(base_url=base, key_identity=kid, key_credential=ksec))
