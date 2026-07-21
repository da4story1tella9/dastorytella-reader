# ADR-0004: Use Riverpod for state management

**Status:** Accepted
**Date:** 2026-07-21

## Context

The app needs a state management approach before any feature screen can be built — library data, playback state, voice selection, and settings all need to be readable and mutable from widgets, testable in isolation, and shareable across the feature-first folder structure described in `ARCHITECTURE.md` §2. This is a solo project (see ADR-0001) written with heavy Claude Code involvement, so predictable, low-ceremony patterns that generate consistently matter more than raw flexibility.

The two realistic candidates, per `ARCHITECTURE.md` §7, are Riverpod and Bloc.

## Decision

Use Riverpod (`flutter_riverpod`) for all app state — library/book data, playback/player state, voice catalog and download status, and settings.

Start with plain `Provider` / `StateProvider` / `NotifierProvider` (no code generation via `riverpod_generator`) to keep the build step simple while the app is small; revisit code generation once provider count grows enough that boilerplate becomes the bottleneck.

## Alternatives Considered

- **Bloc** — mature, battle-tested, explicit event → state transitions. Rejected as the default: the ceremony (events, states, mappers per feature) pays off on large teams that need enforced consistency across many contributors, which doesn't apply here. It's also more verbose to wire into widgets than Riverpod's `ConsumerWidget`/`ref.watch`.
- **`setState` / plain `InheritedWidget`** — no external dependency, but doesn't scale past trivial local state: no clean way to share playback state between the mini-player (visible on every tab) and the full player screen, and harder to unit-test business logic separately from widgets. Rejected.
- **Provider (the package Riverpod supersedes)** — rejected in favor of Riverpod directly; Riverpod fixes Provider's `BuildContext` dependency and runtime-only error surface (compile-time provider errors instead), with no real downside for a new project.

## Consequences

Every feature's `state/` folder (per the structure in `README.md`) holds Riverpod providers/notifiers instead of Bloc classes — this ADR is what that folder name refers to going forward. Widgets that read state extend `ConsumerWidget`/`ConsumerStatefulWidget`. Business logic in providers is unit-testable via `ProviderContainer` without pumping widgets, which fits the testing expectations in `CONTRIBUTING.md`. The main tradeoff: Riverpod's global-provider model requires discipline about provider scoping (e.g. `autoDispose` for per-screen state) or providers can leak state across navigation — worth watching for once the player and library screens both hold non-trivial state.
