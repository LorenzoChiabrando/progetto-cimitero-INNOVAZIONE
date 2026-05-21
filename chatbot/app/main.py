"""FastAPI entrypoint for the Cementerio General chatbot."""

from __future__ import annotations

import logging
import os
from pathlib import Path

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field

from .engine import ChatEngine

logging.basicConfig(
    level=os.environ.get("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s: %(message)s",
)
logger = logging.getLogger("chatbot")


KNOWLEDGE_PATH = Path(__file__).parent / "knowledge.json"
engine = ChatEngine(KNOWLEDGE_PATH)


app = FastAPI(
    title="Cementerio General Chatbot",
    version="1.0.0",
    description="TF-IDF retrieval bot over a curated knowledge base.",
)

# CORS is permissive: the frontend usually proxies through Next.js, but in
# dev someone may call the container directly from the browser.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)


class ChatRequest(BaseModel):
    message: str = Field(..., max_length=500)


class ChatSuggestion(BaseModel):
    id: str | None = None
    question: str
    score: float = 0.0


class ChatReply(BaseModel):
    reply: str
    matched_id: str | None = None
    matched_question: str | None = None
    confidence: float = 0.0
    category: str | None = None
    suggestions: list[ChatSuggestion] = []


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "entries": len(engine.entries)}


@app.get("/welcome")
def welcome() -> dict:
    return {
        "message": engine.welcome_message(),
        "starters": engine.starters(),
    }


@app.get("/faqs")
def faqs() -> dict:
    return {"entries": engine.all_questions()}


@app.post("/chat", response_model=ChatReply)
def chat(req: ChatRequest) -> ChatReply:
    result = engine.answer(req.message)
    return ChatReply(
        reply=result.reply,
        matched_id=result.matched_id,
        matched_question=result.matched_question,
        confidence=round(result.confidence, 4),
        category=result.category,
        suggestions=[ChatSuggestion(**s) for s in result.suggestions],
    )
