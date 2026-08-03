/// Base URL for the daStoryTella backend (`dastorytella-backend`) —
/// see docs/adr/0007-player-real-tts.md.
///
/// Points at a local dev server for now: the backend has no deployed
/// URL yet (its own README: no hosting platform chosen). Every real
/// `/tts/synthesize` call correctly fails with a network error until
/// either a backend is running at this address, or this constant is
/// updated to point at a real deployment.
library;

abstract final class BackendConfig {
  static const String baseUrl = 'http://localhost:8000';
}
