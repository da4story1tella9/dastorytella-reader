# ADR-0006: Mobile app authenticates directly with Supabase

**Status:** Accepted
**Date:** 2026-08-02

## Context

The backend repo (`dastorytella-backend`) decided in its ADR-0003/ADR-0004 that it only *verifies* Supabase-issued JWTs on protected routes — it doesn't handle sign-up, sign-in, or password flows itself. That leaves this app as the side that actually talks to Supabase Auth: sign-in/sign-up screens already exist (`AuthScreen`) but every button on them is a mock that just navigates straight into the app.

A real Supabase project now exists (`DS Reader Mobile`), so there's something real to wire up to. The Sign In mockup (`docs/design-reference/app-mockups-core-batch2.html`) has three static buttons — Apple, Google, "Continue with email" — and nothing else; it never designed an actual email/password form, a loading state, or an error state, because at the time it was drawn none of the three buttons did anything real.

## Decision

- The mobile app talks to Supabase directly via `supabase_flutter`, initialized once in `main.dart` with the project URL and its **publishable key** (`lib/core/config/supabase_config.dart`) — safe to ship in the client, unlike a secret key.
- Only **email/password** is wired to real Supabase calls (`signInWithPassword` / `signUp`) for now, via a Riverpod `AuthController`. This replaces the mockup's static "Continue with email" button with an actual form — same precedent as `AddEntryCard` building real text fields where its mockup only had static placeholders.
- **Apple and Google** stay visually as the mockup drew them, but now show a "not set up yet" message instead of silently navigating into the app. Wiring either for real needs provider-side app registration (Apple Developer / Google Cloud Console) plus matching Supabase provider config — account/dashboard setup, not just code, and out of scope for this slice. Leaving them fake-succeed next to a real form on the same screen would be actively misleading, so "clearly not implemented" is the right interim state, not "pretend it works."
- Supabase's project setting requires confirming a new account's email before it has a session (visible as a distinct `AuthResult.confirmationRequired` outcome from sign-up, separate from both success and failure) — the UI tells the user to check their email rather than assuming sign-up always means "signed in."
- Errors show Supabase's own `AuthException.message` directly — these are already written to be shown to end users (e.g. "Invalid login credentials"), unlike the backend's stance on its *own* internal exceptions (ADR-0002 in that repo), which are a different kind of error entirely (unexpected, and never safe to show verbatim).
- **No app-wide auth gate yet.** The app still opens straight to `/library` regardless of sign-in state — this ADR only makes the sign-in/sign-up screens themselves real, it doesn't decide when the app should require them. That's a separate, bigger decision (session-restore UX, a splash/loading state, what an unauthenticated user can still do) deferred to its own ADR when it's actually needed.

## Alternatives Considered

- **Proxy auth through the backend** (client → `dastorytella-backend` → Supabase) — rejected; already decided against in the backend's own ADR-0003, for the same reason: Supabase's client SDKs and publishable key are built for direct client use.
- **Wire Apple/Google now too** — rejected for this slice. Both need real developer-console app registrations before there's anything to test against; bundling that setup work into this change would block the email/password path on unrelated account provisioning.
- **Store the Supabase URL/key in `.env`-style config instead of a source constant** — rejected. Unlike the backend's secrets, a publishable key is meant to be embedded in the shipped client (it's extractable from the compiled app regardless); routing it through env-var indirection would imitate a security boundary that doesn't actually exist here.

## Consequences

Sign-in/sign-up are now real and independently testable against the actual Supabase project, and session persistence (restoring a signed-in user across app restarts) comes for free from `supabase_flutter` without any code here having to implement it. The screen now has real loading/error states the mockup never anticipated, documented as a deliberate deviation rather than silently drifting from it.

Not yet covered, deferred until needed: an app-wide auth gate, Apple/Google OAuth, password reset (needs deep-link handling to complete, which doesn't exist yet), and any UI for signing out (there's currently no way to end a session from within the app, since nothing depends on being signed in yet).
