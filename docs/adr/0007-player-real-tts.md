# ADR-0007: Player fetches real narration from the backend TTS proxy

**Status:** Accepted
**Date:** 2026-08-02

> Update (2026-08-03): the backend is now deployed to Render (backend repo's ADR-0006). `BackendConfig.baseUrl` points at the real deployment; the "no deployed backend" caveats below are historical context for why it originally pointed at `localhost`, not the current state.

## Context

The backend's TTS proxy (`dastorytella-backend` ADR-0005) and Supabase auth (this repo's ADR-0006, backend's ADR-0004) both exist now, but nothing in the app actually used either — the Player played a bundled placeholder tone (`assets/audio/sample_chapter.wav`) regardless of what chapter/voice was selected. This ADR wires the Player to the backend for real, closing that loop.

The backend caps a single `/tts/synthesize` request at 1000 characters and is explicit that it serves "sentence-level playback," not chapter-level — the ingestion/SSML pipeline that would produce and manage larger chunks doesn't exist yet (`ARCHITECTURE.md` §3). The current mock transcript (three sentences) fits well under that cap, so this ADR scopes to what that proxy already supports: synthesizing one chapter's transcript as a single request, not a multi-request streaming/prefetch pipeline across sentence boundaries. That's real scope for later, once real per-chapter ingestion exists to actually need it.

The backend also has no deployed URL yet (its own README: no hosting platform chosen) — it only runs as a local dev server today.

## Decision

- `NowPlayingController` synthesizes the current track's full transcript text via a new `TTSClient` (`lib/core/tts/tts_client.dart`) on load, instead of loading the bundled placeholder asset. The bundled tone and its pubspec asset entry are removed — once real synthesis exists, a static file with no connection to the actual chapter text isn't a real fallback, just misleading filler (see below on why failures aren't silently papered over with it).
- `TTSClient` attaches the signed-in user's Supabase access token as a bearer header (mirroring exactly what the backend's `get_current_user` expects) and calls `BackendConfig.baseUrl` + `/tts/synthesize`. `BackendConfig.baseUrl` is a plain constant pointing at `http://localhost:8000` for now — there's no deployed backend to point at yet; this needs updating once one exists, same "correctly fails until real config exists" pattern as `SupabaseConfig`.
- **Failures are shown, not silently substituted.** `NowPlayingState` gains `isLoadingAudio`/`loadErrorMessage`, and the Player screen shows a loading banner while synthesizing, or an error banner with a **Retry** button on failure. This matters right now specifically: every real request currently fails with ElevenLabs' `402 payment_required` (free-tier accounts can't use library voices via the API — see backend ADR-0005's discovery), and silently falling back to unrelated placeholder audio would hide that real, expected failure instead of surfacing it honestly.
- The voice ID passed to `/tts/synthesize` is a hardcoded placeholder (ElevenLabs' public "Rachel" voice) — the app has no real voice-selection data yet (Voices screen is still mock), so there's nothing else to pass. Replacing it is tracked alongside the ingestion/voice-data work, not solved here.
- `NowPlayingState.loadErrorMessage` is deliberately not settable through `copyWith` — a nullable field there can't distinguish "leave the error as-is" from "clear it" (the same ambiguity hit and fixed during the auth work). The controller uses a small dedicated `_withLoadState` constructor-wrapper for these two fields instead.

## Alternatives Considered

- **Keep the bundled placeholder as a fallback on synthesis failure** — rejected. It would make the Player *look* like it's working (audio plays) while silently not doing the one thing this ADR sets out to do, and would mask the very real, currently-expected ElevenLabs 402 failure instead of showing it. A real offline fallback (Piper/sherpa-onnx, per `ARCHITECTURE.md` §4) is a legitimate future feature; a static unrelated tone standing in for it today is not — it's filler, not a fallback.
- **Sentence-by-sentence fetch-and-play with prefetching** — rejected for this slice. Real streaming/gapless playback across many small requests is a meaningfully bigger feature (sequencing, prefetch-ahead, cross-sentence seek/position tracking) that only pays off once real per-chapter ingestion produces content too large for one request. Building it against today's three-sentence mock transcript would be speculative complexity for a problem that doesn't exist yet.
- **Deploy the backend now so the app can point at a real URL** — rejected as out of scope here; picking and provisioning a hosting platform is its own decision (and its own external account, same pattern as Supabase/ElevenLabs) that this ADR doesn't need to make in order to get the client-side wiring right.

## Consequences

The Player screen now has genuine loading and error states it never had before, and — once a backend is reachable and a real voice ID exists — will play real narration with zero further code changes on the mobile side. Today, opening the Player will visibly show the ElevenLabs 402 error (via the retry banner) rather than silently playing an unrelated tone, which is the correct, honest state to be in until an API-eligible voice exists.

Not yet covered, deferred until needed: a deployed backend URL, real voice selection (replacing the hardcoded placeholder ID), sentence-level streaming/prefetch, and an offline/local-TTS fallback for when the network or the backend genuinely isn't available.
