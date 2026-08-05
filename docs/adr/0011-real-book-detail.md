# ADR-0011: Real Book Detail — a real chapter actually plays

**Status:** Accepted
**Date:** 2026-08-03

## Context

Every book card and search result has always routed to the same shared mock Book Detail screen (`BookCard`'s own long-standing comment said so directly), regardless of which book was tapped, and every chapter row's `onTap` was a no-op. Library's grid became real in ADR-0010; leaving Book Detail showing fixed mock chapters that do nothing when tapped would have been exactly the kind of half-finished feature this project has avoided at every other step (Player, Voices, Import all went all the way to something real and useful, not partway).

Making chapters real forced a bigger question than just "fetch and display": the shared `NowPlayingController` (ADR-0004, ADR-0007, ADR-0009) has always driven playback from one hardcoded mock track, eagerly synthesized on every app launch regardless of whether the Player was ever opened. Real chapters need a real target to play into, which meant redesigning that controller rather than just wiring a dead end.

## Decision

- **Route gains a real parameter**: `/book/:bookId` (was `/book`). `BookCard` and `SearchBookResultRow` push `book.id`; the latter's mock book IDs correctly resolve to "not found" rather than the route breaking.
- **`GET /books/{id}` (already built, backend ADR-0009) is the fetch** — `BookDetailScreen` uses a `FutureProvider.family<RemoteBook?, String>` keyed by id, with the same loading/error/not-found states established for every other real-data screen this session.
- **`NowPlayingController` no longer eagerly loads anything on startup.** Previously, every app launch synthesized the (mock) transcript via a real backend/ElevenLabs call whether or not the user ever opened the Player — real cost, real rate-limit budget, spent for nothing. Now the initial state is `NowPlayingTrack.empty` (`bookId: ''`), and nothing is synthesized until a chapter is explicitly chosen.
- **A new `playChapter(...)` method** takes real book/chapter data (id, title, cover, chapter index, real sentences) from Book Detail and starts real synthesis of that specific content — the same `_loadAudio` machinery as before, now fed real text instead of a mock constant.
- **The mini-player's visibility now means "something is actually selected to play,"** not "the library happens to have books." Both Library and Book Detail gate it on `nowPlaying.track.bookId.isNotEmpty` instead of the book list's own emptiness — showing a mini-player for a track nobody chose to play would be exactly the kind of fabricated state this project has consistently avoided (ADR-0010's honest-defaults stance, applied here to playback state instead of book metadata).
- **"Current chapter" highlighting only applies when this book is the one actually loaded.** No "done" chapters — there's no persisted reading/listening position (ADR-0010's own deferred item), so every non-current chapter shows a real fact (its sentence count) instead of a fabricated duration or a fabricated "already read" state.
- **`selectedVoiceProvider`** (renamed from `selectedVoiceIdProvider`) now carries the chosen voice's name alongside its id, set together at the one place that already has both (Voice Detail's "Set as default") — needed so the Player can show a real voice label without `core/playback` reaching into `features/voices` to look a name up from just an id, which would invert the intended core-doesn't-depend-on-features layering.
- **Player has a defensive empty-state guard** (`track.bookId.isEmpty`) — in practice unreachable (it's only ever opened via the mini-player or a chapter tap, both of which require a real selection to exist first), but a direct or stale navigation shouldn't render "Chapter 0 of 0" against nothing.
- **Now-dead mock files removed**, not left behind: `mock_now_playing_data.dart`, `mock_book_detail_data.dart`, `chapter_summary.dart`, `book_hero_row.dart` (its progress-percentage-centric design didn't fit "no progress is tracked yet," replaced by a simpler real hero).

## Alternatives Considered

- **Show real chapters but leave `onTap` a no-op, defer playback wiring to a later ADR** — rejected; a chapter list that does nothing when tapped is a worse, more confusing state than the mock it replaces (mock chapters at least matched mock playback state; real chapters showing no relationship to what's playing would be actively misleading).
- **Keep `NowPlayingController`'s eager startup load, just point it at a "first available real book" instead of removing it** — rejected. Still spends a real synthesis call before the user asks for one, and "which book" would be an arbitrary, surprising choice with no real UX justification once genuine libraries can hold more than one book.
- **Nullable `NowPlayingTrack? track` instead of a sentinel `NowPlayingTrack.empty`** — considered, functionally similar. Went with a sentinel to avoid threading null-checks through `NowPlayingState.copyWith` and every existing reader of `.track.X`; `bookId.isEmpty` is one check at the two call sites that actually need to distinguish "selected" from "not," rather than nullability rippling everywhere.
- **Resolve the selected voice's display name from `core/playback` via `features/voices`** — rejected as a dependency-direction problem (`core` reaching into a `feature`); storing the name at selection time, where the caller already has it, avoids that entirely.

## Consequences

The full loop — import a book, browse it, play a real chapter in a real voice — is genuinely real for the first time. The app no longer makes a synthesis call on every launch it doesn't need to. The mini-player and "current chapter" highlighting now only ever reflect something real, never a fabricated default.

Not yet covered, deferred until needed: persisted reading/listening position (chapters can't show "done" without it), sentence-level streaming/prefetch across chapter boundaries (still one request per chapter, per ADR-0007), Bookmarks/Details tabs, and voice-per-book assignment ("Assign to a book" on Voice Detail is still local-only mock state, unrelated to this ADR).
