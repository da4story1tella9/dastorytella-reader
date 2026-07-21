/// Thin HTTP client wrapper for talking to the FastAPI backend.
///
/// Deliberately not implemented yet — placeholder documenting the
/// contract this will fulfill once the backend base URL and auth
/// scheme are finalized (see ARCHITECTURE.md §1, ADR-0003).
///
/// Responsibilities once implemented:
/// - Attach auth token from secure storage to every request
/// - Central error handling / retry policy
/// - Never construct TTS-provider requests directly — always via backend
class ApiClient {
  ApiClient._();
  // TODO(scaffold): implement once backend base URL is available.
}
