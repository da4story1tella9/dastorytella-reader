# daStoryTella's Reader (Mobile)

A mobile ebook reader that turns any book, article, or draft into a punctuation-aware, tone-adaptive listening experience — with real offline voice support.

Companion app to the existing desktop reader (Python/PySide6). This repo is the Flutter-based mobile client.

## Status

🚧 **Real auth gate, backend deployed, player wired up end to end** — navigation shell (Library / Voices / Settings) is wired up (see ADR-0004, ADR-0005), and every screen from `docs/design-reference/` is built and navigable. Sign In / Sign Up do real email/password auth against a live Supabase project (ADR-0006); Apple/Google are still placeholders. A signed-out user is now actually gated to Onboarding — Library/Player/Settings/etc. all require a real session (ADR-0008), with a working "Log out." The Player (`just_audio`) synthesizes its transcript via the backend TTS proxy instead of a bundled tone (ADR-0007), pointing at the backend's real Render deployment — with visible loading/error states, currently showing an error because the ElevenLabs key in use is free-tier and can't call its library voices via the API yet. Library/voice data is still all mock — that's next.

## Tech Stack

| Layer | Choice | Why |
|---|---|---|
| Frontend | Flutter (Dart) | Single codebase for iOS + Android; mature audio plugin ecosystem |
| Backend | FastAPI | Proxies all TTS calls (never expose API keys client-side); familiar from BetIQ. Player calls it (ADR-0007); not deployed anywhere yet, local dev only |
| Database / Sync | Supabase (Postgres) | Auth wired up (email/password, ADR-0006); library sync planned |
| Cloud TTS | Azure Cognitive Services, ElevenLabs | Punctuation-aware SSML support, style/emotion parameters |
| Offline TTS | Piper (ONNX) via `sherpa-onnx` | Same engine as desktop reader; downloadable voice packs |
| Text parsing | EbookLib/BeautifulSoup, PyMuPDF, pysbd (backend) | Reused from desktop reader's ingestion pipeline |

See [`ARCHITECTURE.md`](./ARCHITECTURE.md) for the full system design and [`docs/adr/`](./docs/adr) for the reasoning behind key decisions.

## Getting Started

> Prerequisites: Flutter SDK installed, Dart 3.x, an editor with Flutter/Dart plugins (VS Code recommended).

```bash
flutter pub get
flutter run
```

Run tests:
```bash
flutter test
```

Run static analysis (lint):
```bash
flutter analyze
```

## Project Structure

```
lib/
  core/            → theming, constants, network client, shared utilities
  features/        → one folder per feature, each self-contained
    library/
    player/
    voices/
    settings/
    onboarding/
    search/
  shared_widgets/  → reusable design-system components (buttons, chips, cards)
test/
  unit/            → business logic (SSML generation, caching, etc.)
  widget/          → individual widget behavior
  integration/     → full user flows (import → parse → play)
```

Each feature folder follows the same internal shape:
```
features/<name>/
  screens/   → top-level screen widgets
  widgets/   → widgets private to this feature
  models/    → data classes for this feature
  state/     → state management for this feature
```

## Design System

The visual language (colors, typography, component patterns) was designed and validated as HTML mockups before implementation — see `docs/design-reference/` (mockup files) and `lib/core/theme/` (the Flutter implementation of those tokens).

Palette: warm paper base (`#FAF7F1`), maroon (`#7A2E34`) and gold (`#C98A2E`) as accent — never as full-screen wash. Typography: Fraunces (serif, titles) + Manrope (sans, UI chrome).

## Contributing

See [`CONTRIBUTING.md`](./CONTRIBUTING.md) for coding conventions, commit format, and branch strategy.

## Changelog

See [`CHANGELOG.md`](./CHANGELOG.md) — follows [Keep a Changelog](https://keepachangelog.com/) format.

## License

See [`LICENSE`](./LICENSE).
