# Contributing Guide

Conventions for this project. Solo-project now, but written as if a second person joins tomorrow — that's the point of documenting it.

## Code Style

- Follow [Effective Dart](https://dart.dev/effective-dart) — Google's official style guide.
- Enforced via `flutter analyze` using the ruleset in `analysis_options.yaml` (built on `flutter_lints`).
- Run `flutter analyze` before every commit. CI will block merges on lint failures (see `.github/workflows/ci.yml`).
- Public classes, methods, and widgets get a `///` dartdoc comment describing purpose — not restating the signature.

## Commit Messages — Conventional Commits

Format: `<type>(<scope>): <description>`

Types used in this project:
| Type | Use for |
|---|---|
| `feat` | New feature or screen |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no logic change |
| `refactor` | Code change that's neither a fix nor a feature |
| `test` | Adding or correcting tests |
| `chore` | Tooling, dependencies, config |

Examples:
```
feat(player): add live sentence highlight sync
fix(voices): correct offline badge showing on cloud-only voices
docs(architecture): record ADR-0004 state management decision
```

Why: readable git history, and `CHANGELOG.md` entries can be generated directly from commit messages.

## Branch Strategy

- `main` — always stable / buildable
- `feature/<short-name>` — one branch per feature or fix (e.g. `feature/library-screen`, `fix/waveform-overflow`)
- Merge to `main` via PR, even solo — keeps a reviewable record and lets CI gate the merge

## Architecture Decision Records (ADRs)

Any decision with long-term structural consequences (state management, a new major dependency, a data-model change) gets an ADR in `docs/adr/`, using `docs/adr/template.md`. Numbered sequentially, never renumbered or deleted — superseded decisions get a new ADR that references the old one.

Rule of thumb: if you'd have to re-derive *why* six months from now, it's ADR-worthy.

## Testing Expectations

- New business logic (SSML generation, caching keys, parsing) → unit test in `test/unit/`
- New shared widget → widget test in `test/widget/`
- New critical user flow → integration test in `test/integration/`
- No formal coverage % gate yet — to be set once the core feature set stabilizes (tracked as an open item in `ARCHITECTURE.md`)

## Design System Changes

Any change to color, typography, or core component styling should be reflected first in the HTML mockups (`docs/design-reference/`) before being implemented in `lib/core/theme/` — keeps the two from drifting apart.
