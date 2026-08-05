# ADR-0010: Import a real book — Library fetches real data

**Status:** Accepted
**Date:** 2026-08-03

## Context

The backend can now parse an EPUB (`dastorytella-backend` ADR-0008) and persist a book with real Row-Level-Security-protected chapters (ADR-0009), but nothing in the app used either — Library has only ever shown four hardcoded mock books, and the "Import your first book" CTA on the empty-state screen has always been a no-op (`onTap: () {}`). This ADR closes that loop: a real file picker, a real upload-parse-save flow, and a Library grid backed by real data.

## Decision

- **Library's Saved segment is real now** (`state/library_providers.dart`): `LibraryBooksController` (`AsyncNotifier<List<Book>>`) fetches from the backend's `GET /books`, mapped onto the existing UI `Book` model (`state/book_mapper.dart`) — same "keep the existing model, add a mapper" approach as the Voices feature's `voice_mapper.dart`. Collections/Archive stay hardcoded empty; no backend concept for either exists yet, same gap as before this ADR.
- **A new "+" icon on the Library app bar, and the empty-state CTA, both trigger a real import flow** (`state/import_controller.dart`): pick a file (`file_picker`, EPUB only), upload it to `POST /ingestion/parse`, then save the result via `POST /books`, then refresh the library list. Loading/error states follow the pattern established for the Player (ADR-0007) and Voices (ADR-0009) — a small spinner while importing, a `SnackBar` on completion (success or a safe error message), never a silent failure.
- **Book Detail stays fully mock, deliberately.** `BookCard` already routed every book — mock or real — to the same shared mock detail screen before this ADR (its own comment says so); tapping a real book still does that. This isn't a new gap introduced here, and building real per-book detail (chapters list, "currently playing" position, voice assignment) is substantial enough to warrant its own ADR once it's actually being built, not a rider on this one.
- Fields the backend doesn't have yet get honest, not fabricated, defaults: `byline` shows a real chapter count ("3 chapters") instead of a fake narrator name (no voice-per-book assignment is persisted — `ARCHITECTURE.md`'s Book/Voice association isn't built); `progress` is `0.0` (no reading/listening position is persisted); `isDownloaded` is always `false` (no offline system exists). Cover gradient is assigned deterministically by book ID from a small fixed palette, same technique as Voices' avatar gradients — there's no real cover art (no cover-image ingestion exists).
- `file_picker` requests `withData: true` (loads the file into memory as bytes) rather than only a file path — needed for the app to work on web, and harmless on mobile/desktop, where 25MB-or-smaller EPUBs (the backend's own upload cap) in memory briefly is not a real concern.

## Alternatives Considered

- **Wire real per-book detail (chapters, playback) in this same PR** — rejected; `BookCard`'s existing shared-mock-detail behavior isn't a regression this ADR introduces, so there's no urgency forcing it in here, and it's large enough to deserve its own scoped ADR once actually built.
- **Show fabricated byline/progress data instead of honest defaults** — rejected outright. A fake "Amara · Warm Narrative" byline on a book that has no voice assigned would actively misrepresent the app's state to the user, which is worse than an honest "3 chapters."
- **Read file bytes lazily from a path instead of `withData: true`** — rejected; would need per-platform branching (path-based reads don't work on Flutter web) for a memory concern that isn't real at EPUB file sizes.

## Consequences

The full loop is real for the first time: parse a real EPUB, save it, see it in your library. This is the first feature in the app where "your library" means something — every prior screen was either fully mock or, at most, real browsing/preview data (Voices) without anything actually being *yours*.

Not yet covered, deferred until needed: real Book Detail (chapters, playback, voice assignment), reading/listening position persistence, PDF/DOCX/TXT ingestion (backend-side, `dastorytella-backend` ADR-0008's own deferred list), Collections/Archive, and any delete/rename/re-import handling for a book already in the library.
