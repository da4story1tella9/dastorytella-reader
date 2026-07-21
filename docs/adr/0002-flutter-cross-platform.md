# ADR-0002: Use Flutter for the mobile client

**Status:** Accepted
**Date:** 2026-07-19

## Context

The app needs iOS and Android support, background audio playback with lock-screen controls, on-device ONNX inference for offline TTS voices, and binary file parsing (EPUB/PDF). No-code builders were evaluated and ruled out early — they don't expose the native audio session and file-parsing APIs this app depends on.

## Decision

Build the mobile client in Flutter (Dart), targeting a single codebase for iOS and Android.

## Alternatives Considered

- **React Native** — viable alternative given existing Node/npm familiarity from document-generation tooling. Ruled out in favor of Flutter due to a more mature native-audio plugin ecosystem (`just_audio`, `sherpa-onnx` bindings) for this specific use case.
- **Separate native apps (Swift + Kotlin)** — rejected; doubles implementation and maintenance effort with no clear benefit for this app's requirements.
- **No-code builders (FlutterFlow, Adalo, Bubble)** — rejected; cannot support background audio sessions, on-device ONNX inference, or low-level file parsing.

## Consequences

Requires learning Dart syntax (moderate lift given existing Python background — closer than JS in some respects, e.g. strong typing). Gains a mature single-codebase story and a good agentic-coding fit (Claude Code + Flutter is a well-trodden combination).
