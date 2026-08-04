# ADR-0008: App-wide auth gate

**Status:** Accepted
**Date:** 2026-08-03

## Context

Real Supabase auth has existed since ADR-0006, but it was entirely optional: the app opened straight to `/library` regardless of sign-in state, and the sign-in/sign-up screens were only reachable by explicitly navigating to them. OnboardingScreen's own doc comment already flagged this as temporary — it was always meant to become the app's actual startup gate once real auth existed to gate on. This ADR finishes that.

The Settings screen already had a "Log out" row (added ahead of this ADR "so Onboarding/Sign In have a real in-app entry point"), but it only navigated to `/onboarding` — it never actually cleared the Supabase session, by its own doc comment's admission, since there was no session to clear until ADR-0006.

## Decision

- A new `isSignedInProvider` (`core/auth/auth_gate.dart`) tracks whether a Supabase session currently exists, kept live via `Supabase.instance.client.auth.onAuthStateChange` rather than a one-time check — so sign-in/sign-out react immediately without needing an app restart.
- `app_router.dart` gains a `redirect` callback: signed-out users are sent to `/onboarding` from anywhere except the onboarding/sign-in/sign-up flow itself and the legal pages (`/terms`, `/privacy-policy`, which must stay readable without an account); signed-in users are redirected away from the onboarding/auth screens straight to `/library`. A small `_AuthRefreshListenable` bridges `isSignedInProvider`'s Riverpod state to go_router's `refreshListenable`, so a sign-in/out re-evaluates the gate immediately rather than waiting for the next explicit navigation.
- **Explicit in-flow navigation is kept alongside the gate, not replaced by it** — `AuthScreen` still calls `context.go('/library')` on sign-in success, and the "Log out" row still calls `context.go('/onboarding')` after signing out, even though the redirect would eventually catch both on its own. The gate is the safety net (stale deep link, browser back button, an already-expired session on relaunch); explicit navigation is what actually drives the normal-path UX, so it isn't purely dependent on stream-timing.
- "Log out" now calls a real `AuthController.signOut()` (`Supabase.instance.client.auth.signOut()`) instead of just navigating.
- `AuthGateController` degrades to "signed out" (rather than throwing) if Supabase was never initialized — true in every widget test, since none of them call `main()`/`Supabase.initialize()`. This is deliberate, not a workaround bolted on after the fact: it's the same safe-default reasoning used throughout this app's Supabase integration (a missing/broken auth state should never grant access, only ever deny it). The three existing widget tests that need a signed-in gate (Library/Player/Book Detail flows) now explicitly override `isSignedInProvider` with a fake via `ProviderScope`, and a new test (`auth_gate_test.dart`) exercises the real controller's default fallback directly, proving the gate itself works rather than just asserting it in isolation.

## Alternatives Considered

- **Check `currentSession` once at router-build time instead of a reactive stream** — rejected. Would correctly gate on launch, but wouldn't react to a sign-in or sign-out that happens *after* the router already exists — the whole point of also having explicit `context.go(...)` calls as a fast-path, with the reactive gate as a backstop, is defeated if the backstop itself doesn't actually react.
- **Redirect based on a snapshot read inside `redirect` alone, no `refreshListenable`** — rejected. go_router's `redirect` only re-runs on an actual navigation event; without `refreshListenable` notifying it, a sign-out while sitting on a screen that requires auth wouldn't trigger a redirect until the user happened to navigate somewhere else.
- **Let widget tests hit the real "signed out" gate and just update their assertions to expect Onboarding** — rejected for the three existing navigation tests; their entire point is exercising Library/Player/Book Detail flows, which requires being signed in as their actual test setup, not a workaround. (This is exactly what the new dedicated `auth_gate_test.dart` does instead, for the signed-out case specifically.)

## Consequences

Signing in and signing out now mean something app-wide, not just within the auth screens themselves — the first real payoff of ADR-0006's work. A signed-out user can no longer reach Library, Player, Settings, or any other gated screen by direct navigation or a stale link; they land on Onboarding instead.

Not yet covered, deferred until needed: a distinct "checking session" splash state (unnecessary today since `Supabase.initialize()` already completes, session restore included, before `runApp()` in `main.dart` — there's no real async gap to cover), and remembering a user's intended destination through the sign-in flow (today, a signed-out deep link always lands on Onboarding, not "sign in, then continue to where you were headed").
