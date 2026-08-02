/// Outcome of a sign-in/sign-up attempt, distinct from [AuthFormState]
/// (which only tracks in-progress/error UI state) because the screen
/// needs to react differently to each case — navigate in, or explain
/// that email confirmation is pending — and only one of those is an
/// error.
enum AuthResult {
  signedIn,

  /// Supabase's default project setting requires confirming a new
  /// account's email before it has an active session — sign-up
  /// succeeded, but there's no session to navigate in with yet.
  confirmationRequired,

  failure,
}
