"""TF-IDF retrieval engine for the Cementerio General chatbot.

The knowledge base is a small JSON file with hand-written Q&A entries.
At construction time we build one TF-IDF matrix over the concatenation of
each entry's question + tags + category, then answer queries by cosine
similarity against that matrix.

No external model, no network call — deterministic and offline.
"""

from __future__ import annotations

import json
import logging
import random
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Optional

import numpy as np
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

logger = logging.getLogger(__name__)


# Confidence threshold below which we treat the answer as "no good match".
# Calibrated empirically on the bundled knowledge base.
MATCH_THRESHOLD = 0.22


@dataclass
class KnowledgeEntry:
    id: str
    category: str
    question: str
    tags: list[str]
    answer: str

    @property
    def index_text(self) -> str:
        # Repeat the question + tags so they outweigh the category term.
        return " ".join([
            self.question,
            self.question,
            " ".join(self.tags),
            " ".join(self.tags),
            self.category,
        ])


@dataclass
class ChatResponse:
    reply: str
    matched_id: Optional[str]
    matched_question: Optional[str]
    confidence: float
    suggestions: list[dict]
    category: Optional[str]


GREETING_PATTERNS = (
    r"^\s*(hi|hello|hey|hola|ciao|buongiorno|buenas|good\s+(morning|evening|afternoon))\b"
)
THANK_PATTERNS = r"^\s*(thanks|thank you|gracias|grazie|cheers)\b"


class ChatEngine:
    def __init__(self, knowledge_path: Path) -> None:
        with knowledge_path.open("r", encoding="utf-8") as f:
            raw = json.load(f)

        self.greetings: list[str] = raw.get("greetings", [])
        self.fallback: str = raw.get("fallback", "I don't have an answer for that yet.")
        self.suggested_starters: list[str] = raw.get("suggested_starters", [])

        self.entries: list[KnowledgeEntry] = [
            KnowledgeEntry(
                id=e["id"],
                category=e.get("category", "general"),
                question=e["question"],
                tags=e.get("tags", []),
                answer=e["answer"],
            )
            for e in raw.get("entries", [])
        ]

        if not self.entries:
            raise ValueError("Knowledge base contains no entries")

        # Fit the TF-IDF once; cheap on this size.
        self._vectorizer = TfidfVectorizer(
            lowercase=True,
            stop_words="english",
            ngram_range=(1, 2),
            sublinear_tf=True,
            min_df=1,
        )
        self._matrix = self._vectorizer.fit_transform(
            [e.index_text for e in self.entries]
        )

        logger.info(
            "ChatEngine ready: %d entries, vocab=%d",
            len(self.entries),
            len(self._vectorizer.vocabulary_),
        )

    # ── public API ────────────────────────────────────────────────────

    def welcome_message(self) -> str:
        return random.choice(self.greetings) if self.greetings else "Hello!"

    def starters(self) -> list[str]:
        return list(self.suggested_starters)

    def all_questions(self) -> list[dict]:
        return [
            {"id": e.id, "category": e.category, "question": e.question}
            for e in self.entries
        ]

    def answer(self, message: str) -> ChatResponse:
        msg = (message or "").strip()
        if not msg:
            return ChatResponse(
                reply="Please type a question — I'm listening.",
                matched_id=None,
                matched_question=None,
                confidence=0.0,
                suggestions=self._starter_suggestions(),
                category=None,
            )

        # Greeting / thanks shortcuts — short messages that look like small talk
        # should not be matched against the KB.
        if re.match(GREETING_PATTERNS, msg, re.IGNORECASE) and len(msg.split()) <= 4:
            return ChatResponse(
                reply=self.welcome_message(),
                matched_id=None,
                matched_question=None,
                confidence=1.0,
                suggestions=self._starter_suggestions(),
                category="smalltalk",
            )
        if re.match(THANK_PATTERNS, msg, re.IGNORECASE) and len(msg.split()) <= 4:
            return ChatResponse(
                reply="You're welcome — happy to help.",
                matched_id=None,
                matched_question=None,
                confidence=1.0,
                suggestions=[],
                category="smalltalk",
            )

        query_vec = self._vectorizer.transform([msg])
        sims = cosine_similarity(query_vec, self._matrix)[0]
        top_idx = int(np.argmax(sims))
        top_score = float(sims[top_idx])

        if top_score < MATCH_THRESHOLD:
            return ChatResponse(
                reply=self.fallback,
                matched_id=None,
                matched_question=None,
                confidence=top_score,
                suggestions=self._top_suggestions(sims, k=4, exclude_idx=None),
                category=None,
            )

        best = self.entries[top_idx]
        return ChatResponse(
            reply=best.answer,
            matched_id=best.id,
            matched_question=best.question,
            confidence=top_score,
            suggestions=self._top_suggestions(sims, k=3, exclude_idx=top_idx),
            category=best.category,
        )

    # ── helpers ───────────────────────────────────────────────────────

    def _top_suggestions(self, sims: np.ndarray, k: int, exclude_idx: Optional[int]) -> list[dict]:
        order = np.argsort(-sims)
        out: list[dict] = []
        for idx in order:
            i = int(idx)
            if exclude_idx is not None and i == exclude_idx:
                continue
            if sims[i] <= 0:
                continue
            out.append({
                "id": self.entries[i].id,
                "question": self.entries[i].question,
                "score": float(sims[i]),
            })
            if len(out) >= k:
                break
        if out:
            return out
        return self._starter_suggestions()[:k]

    def _starter_suggestions(self) -> list[dict]:
        return [{"id": None, "question": q, "score": 0.0} for q in self.suggested_starters]
