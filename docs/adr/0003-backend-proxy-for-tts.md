# ADR-0003: Proxy all cloud TTS calls through a backend

**Status:** Accepted
**Date:** 2026-07-19

## Context

Cloud TTS providers (Azure Cognitive Services, ElevenLabs) require API keys. Mobile app binaries can be decompiled, and embedded secrets are reliably extracted within days of a public release. Cloud TTS is also billed per character, creating a direct cost-exploit risk if a client can call providers unthrottled.

## Decision

All cloud TTS synthesis requests are routed through a FastAPI backend, which holds provider API keys server-side and enforces per-user rate limiting. The Flutter client never holds a cloud TTS provider key.

## Alternatives Considered

- **Call TTS providers directly from the client** — rejected outright; key exposure and no cost control.
- **Use a third-party BaaS with built-in key vaulting** — considered, but a thin FastAPI proxy gives more control over caching (see ADR-0005) and reuses existing FastAPI familiarity from the BetIQ project.

## Consequences

Adds backend infrastructure that must be deployed and maintained (vs. a fully client-only app). In exchange: no key exposure, cost control via rate limiting, and a natural place to implement the audio caching layer.
