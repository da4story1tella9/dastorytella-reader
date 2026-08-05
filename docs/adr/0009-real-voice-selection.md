# ADR-0009: Real voice browsing, preview, and default selection

**Status:** Accepted
**Date:** 2026-08-03

## Context

The Voices/Voice Detail screens have only ever shown four hardcoded mock voices ("Amara," "Kwame," "Nadia," "Tobi"), and `NowPlayingController` has always synthesized against one hardcoded ElevenLabs voice ID regardless of anything shown there — the two were never connected. Real synthesis has worked since the ElevenLabs account moved to a paid plan (`docs/adr/0007-player-real-tts.md`'s update note); this ADR is what makes voice *choice* real too, using the backend's new `GET /tts/voices` (backend repo's ADR-0007).

Building the backend endpoint surfaced that the ElevenLabs API key needed a permission it didn't have (`voices_read` — the key was deliberately scoped to Text-to-Speech only when created). That's covered in the backend ADR; this one starts from the endpoint already working.

## Decision

- `VoicesController` (`features/voices/state/voices_providers.dart`) is an `AsyncNotifier<List<Voice>>` fetching from `GET /tts/voices` via `TTSClient.listVoices()`, replacing the mock list. Riverpod's `AsyncValue` gives loading/error/data states for free; Voices screen and Voice Detail both render a loading spinner or an error-with-retry banner while unresolved, matching the pattern already established for the Player (ADR-0007).
- A `voice_mapper.dart` converts the backend's raw `RemoteVoice` shape onto the *existing* UI-facing `Voice` model (same fields the mock data always populated) rather than redesigning the model or the cards/detail screen around ElevenLabs' shape directly — avatar gradient/initial are derived deterministically from the voice ID (a fixed 4-color palette, picked by hash) since ElevenLabs voices don't carry a color; `isOfflineReady` is always `false` for every real (cloud) voice, since offline TTS is a wholly separate, unbuilt system (`ARCHITECTURE.md` §4).
- **Voice Detail's "Set as default" now writes to a real, shared `selectedVoiceIdProvider`** (`core/tts/selected_voice.dart`), and `NowPlayingController` reads it (at load time, not reactively watched — see below) instead of a hardcoded voice ID constant. This is the first time picking a voice anywhere in the app actually changes what narrates playback.
- **Voice Detail's avatar becomes a real "Play preview" button**, playing ElevenLabs' own `preview_url` (a public CDN URL — playable directly, no backend round trip needed) via a dedicated local `AudioPlayer`, separate from the shared `NowPlayingController` (a voice preview isn't "now playing" a chapter).
- **The "HEAR HOW IT HANDLES…" sample cards stay visual-only**, not wired to real per-sample synthesis, even though `/tts/synthesize` could technically produce real audio demonstrating those exact excerpts. Deferred deliberately — see Alternatives.
- **Favorite and "assign to a book" stay exactly as they were**: local-only `StatelessWidget`/`setState` UI state, unrelated to ElevenLabs data and out of this ADR's scope (no book-voice data model exists yet — that's ingestion/data-model territory).
- Search screen's mock voice data (`mock_voices_data.dart`) is untouched — it's a separate, still-fully-mock screen that wasn't in scope here, so the file stays for its sake even though Voices/Voice Detail no longer use it.

## Alternatives Considered

- **Wire the two "HEAR HOW IT HANDLES…" samples to real synthesis** (call `/tts/synthesize` per sample text, per voice) — genuinely tempting, since it would demonstrate the app's actual punctuation-aware core differentiator better than ElevenLabs' own generic preview does. Deferred rather than rejected outright: it needs its own per-sample loading/playing state (two more small state machines on top of the one just added for the hero preview) and consumes the character-rate-limit budget on every demo listen. Worth doing as a fast, well-scoped follow-up once this slice ships, not bundled in now.
- **Live-reactive voice switching** (re-synthesize an already-loaded chapter immediately when the default voice changes elsewhere) — rejected for this slice. `NowPlayingController` reads the selected voice once, at load time; changing the default while a chapter is already playing takes effect on the *next* load, not immediately. Matches ADR-0007's own established boundary (no reactive re-synthesis mid-session) rather than introducing a new one.
- **Give `Voice` a shape that mirrors `RemoteVoice` directly** — rejected; Search still depends on the existing mock-compatible shape, and the cards/detail UI were already built against it. A mapper function is a smaller, more contained change than redesigning the model and every widget that renders it.

## Consequences

Voices and Voice Detail show a real, current catalog, a real preview a user can actually hear before choosing, and picking one genuinely changes future narration — the first time any voice-related UI in the app has been backed by real data or had a real effect. Restarting the app resets the selection back to the default voice ID, since there's no persisted per-user preference yet.

Not yet covered, deferred until needed: real synthesis for the two sample cards, live-reactive voice switching mid-playback, persisting the selected voice across app restarts (needs the User/preferences model, `ARCHITECTURE.md` §5, not yet built), and any concept of "offline-available" voices.
