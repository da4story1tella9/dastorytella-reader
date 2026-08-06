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

  /// For ordinary JSON requests — generous enough to absorb a cold
  /// start (see above) on top of the actual round trip, which a
  /// tighter timeout would otherwise abort before the real response
  /// ever arrives.
  static const Duration requestTimeout = Duration(seconds: 90);

  /// For `/ingestion/parse` specifically — a cold start plus actually
  /// parsing an uploaded file measured at ~80s for a small EPUB,
  /// so this needs more headroom than [requestTimeout] to cover
  /// larger files too.
  static const Duration uploadTimeout = Duration(seconds: 150);
}
