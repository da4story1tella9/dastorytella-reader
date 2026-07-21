# Architecture

This document describes the system design and the reasoning behind it. For narrower, dated decisions, see [`docs/adr/`](./docs/adr) — Architecture Decision Records. This file describes the current state; ADRs describe how we got here.

## 1. System Overview

```
┌─────────────────┐      ┌──────────────────┐      ┌────────────────────┐
│   Flutter App    │ ───▶ │   FastAPI Backend │ ───▶ │  Cloud TTS Providers │
│  (iOS / Android) │      │   (TTS proxy,     │      │  (Azure, ElevenLabs) │
│                  │ ◀─── │    auth, sync)    │ ◀─── │                      │
└────────┬─────────┘      └─────────┬─────────┘      └─────────────────────┘
         │                          │
         │                          ▼
         │                 ┌──────────────────┐
         │                 │  Supabase (Postgres) │
         │                 │  auth · library · sync│
         │                 └──────────────────┘
         ▼
┌──────────────────┐
│ On-device (Piper/  │
│ ONNX offline voices)│
└──────────────────┘
```

**Why a backend at all, rather than calling TTS providers directly from the app?**
Cloud TTS API keys must never ship inside a mobile binary — they'd be extracted within days. All cloud TTS calls are proxied through FastAPI, which also handles per-user rate limiting (neural TTS is billed per character) and response caching. See ADR-0003.

## 2. Client Architecture (Flutter)

**Pattern: feature-first folder structure.**
Each feature (`library`, `player`, `voices`, `settings`, `onboarding`, `search`) is self-contained: its own screens, widgets, models, and state. Shared code lives in `core/` (theming, network, constants) and `shared_widgets/` (design-system components used across features). This scales better than a layer-first structure (`models/`, `views/`, `controllers/` at the top level) once the app has more than a handful of screens — related code stays together instead of spreading across three top-level folders per feature.

**State management:** Riverpod (`flutter_riverpod`) — see ADR-0004.

**Navigation:** `go_router`, with a `StatefulShellRoute.indexedStack` for the Library / Voices / Settings bottom nav — see ADR-0005.

## 3. Text-to-Speech Pipeline

This is the core differentiator, so it gets documented in more detail than a typical feature.

1. **Ingestion** — EPUB/PDF/DOCX/TXT parsed into structured chapters (reuses logic patterns from the desktop reader's `EbookLib`/`BeautifulSoup`/`PyMuPDF` pipeline, ported to the backend).
2. **Sentence segmentation** — via `pysbd` (same library as desktop reader), producing clean sentence-level units.
3. **SSML generation** — sentences converted to SSML with explicit punctuation-driven prosody: `<break>` tags for commas/periods, pitch contours for questions, emphasis for exclamations.
4. **(Optional) Context tagging pass** — an LLM pre-processing step tags dialogue vs. narration, emotional tone, etc., mapping to provider-specific style parameters (Azure Neural styles, ElevenLabs emotional tags). This runs once per chapter/paragraph, not per playback — output is cached.
5. **Synthesis** — SSML sent to cloud provider (online) or local Piper ONNX model (offline), producing audio.
6. **Caching** — generated audio cached server-side, keyed by `(text_hash, voice_id, style_tags)`. Never regenerate audio for previously-synthesized content — this is the primary cost and latency lever (see ADR-0005).

## 4. Offline Voice Architecture

Piper models (ONNX format, ~20–100MB per voice) are downloaded on-device and run via `sherpa-onnx`. SSML fidelity is lower offline than cloud — this is a known, accepted tradeoff (see ADR-0006), not a bug to chase into parity.

## 5. Data Model (high-level)

- **User** — auth identity, preferences (default voice, playback speed)
- **Book** — metadata, source format, parsed chapter structure, cover art
- **Chapter** — ordered sentences, cached audio references, reading/listening position
- **Voice** — provider, style tags, offline-availability flag, download status
- **PronunciationEntry** — word → override pronunciation, scoped globally or per-book

## 6. Quality Attributes (mapped to ISO/IEC 25010)

| Attribute | How it's addressed here |
|---|---|
| Functional suitability | Feature scope defined per screen in design mockups before implementation |
| Performance efficiency | Audio caching, progressive streaming, prefetch-on-Wi-Fi-only |
| Reliability | Offline fallback voices; graceful degradation when cloud TTS unavailable |
| Security | No client-side API keys; tokens in Keychain/Keystore; backend rate limiting |
| Maintainability | Feature-first structure; ADRs for major decisions; `flutter analyze` in CI |
| Portability | Single Flutter codebase, iOS + Android |

## 7. Open Decisions

Tracked as ADRs once resolved.

Resolved:
- State management library → Riverpod (ADR-0004)
- Navigation library → `go_router` (ADR-0005)

Currently open:
- Exact cloud TTS provider mix at launch (Azure only, or Azure + ElevenLabs from day one)
