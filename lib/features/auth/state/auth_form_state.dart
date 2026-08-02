/// UI state for the sign-in/sign-up form (see AuthController).
library;

class AuthFormState {
  const AuthFormState({this.isSubmitting = false, this.errorMessage});

  final bool isSubmitting;

  /// A message safe to show directly — either one of Supabase's own
  /// auth error messages (e.g. "Invalid login credentials"), which are
  /// already written for end users, or a generic fallback for
  /// anything else (network failure, etc.).
  final String? errorMessage;
}
