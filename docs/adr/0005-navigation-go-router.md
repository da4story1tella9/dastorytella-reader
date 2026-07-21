# ADR-0005: Use go_router for navigation

**Status:** Accepted
**Date:** 2026-07-21

## Context

The app needs a navigation shell before any feature screen can be wired up: a persistent bottom nav (Library / Voices / Settings) where each tab keeps its own navigation stack, plus deeper flows off of it (book detail, player, voice detail, import sheet, onboarding). `ARCHITECTURE.md` §7 already assumed `go_router` as the likely default; this ADR confirms it and records why.

Two things this app will eventually need that push the answer toward a declarative router rather than imperative `Navigator.push`: deep links (e.g. opening a shared article/book link into the import flow) and a bottom nav where switching tabs doesn't lose each tab's scroll/navigation position.

## Decision

Use `go_router` for all navigation, with a `StatefulShellRoute.indexedStack` for the bottom nav shell (Library / Voices / Settings) so each tab preserves its own navigation state when switching tabs.

## Alternatives Considered

- **Imperative `Navigator` (`Navigator.push`/`MaterialPageRoute`)** — no extra dependency, and fine for a single-stack app. Rejected because it has no built-in answer for preserving per-tab navigation stacks under a bottom nav (would need hand-rolled `IndexedStack` + `Navigator` management) and no clean deep-link parsing story.
- **Navigator 2.0 hand-rolled (`Router`/`RouteInformationParser` directly)** — the mechanism `go_router` is built on; rejected as the direct choice because it's low-level ceremony `go_router` already solves well, with no project-specific need to bypass it.
- **`auto_route`** — comparable declarative router with code generation. Considered, but `go_router` is Flutter-team maintained (lower long-term abandonment risk) and avoids adding a `build_runner` step this early; revisit only if `go_router`'s type-safety-via-strings friction becomes a real problem.

## Consequences

Route paths become a small piece of app-wide contract (`/library`, `/voices`, `/settings`, plus nested detail routes) defined once in `lib/core/router/`. The bottom-nav shell widget and the theme's active/inactive nav colors (`AppColors.maroon` / `AppColors.inkFaint`) live together in one place rather than being re-derived per screen. Deep linking and web-style URLs come essentially for free later. Tradeoff: route names/paths are plain strings unless a code-generation layer (`go_router_builder`) is added on top, so a typo in a route path fails at runtime, not compile time — acceptable for the current app size, worth reconsidering if the route count grows a lot.
