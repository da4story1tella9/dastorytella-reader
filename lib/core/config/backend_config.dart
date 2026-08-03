/// Base URL for the daStoryTella backend (`dastorytella-backend`) —
/// see docs/adr/0007-player-real-tts.md.
///
/// Points at the backend's real deployment (Render, backend repo's
/// ADR-0006) rather than a local dev server — reachable from a real
/// device, not just this machine. Its free tier sleeps after 15
/// minutes idle, so the first request after a lull can take ~30-60s.
library;

abstract final class BackendConfig {
  static const String baseUrl = 'https://dastorytella-backend.onrender.com';
}
