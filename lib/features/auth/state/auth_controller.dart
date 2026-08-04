/// Drives real Supabase email/password sign-in and sign-up (see
/// docs/adr/0006-mobile-supabase-auth.md). OAuth providers (Apple,
/// Google) aren't wired up yet — see AuthScreen for how those buttons
/// currently behave instead.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth_form_state.dart';
import 'auth_result.dart';

class AuthController extends Notifier<AuthFormState> {
  @override
  AuthFormState build() => const AuthFormState();

  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    state = const AuthFormState(isSubmitting: true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      state = const AuthFormState();
      return AuthResult.signedIn;
    } on AuthException catch (error) {
      state = AuthFormState(errorMessage: error.message);
      return AuthResult.failure;
    } catch (_) {
      state = const AuthFormState(errorMessage: _genericErrorMessage);
      return AuthResult.failure;
    }
  }

  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    state = const AuthFormState(isSubmitting: true);
    try {
      final AuthResponse response = await Supabase.instance.client.auth
          .signUp(email: email, password: password);
      state = const AuthFormState();
      return response.session != null
          ? AuthResult.signedIn
          : AuthResult.confirmationRequired;
    } on AuthException catch (error) {
      state = AuthFormState(errorMessage: error.message);
      return AuthResult.failure;
    } catch (_) {
      state = const AuthFormState(errorMessage: _genericErrorMessage);
      return AuthResult.failure;
    }
  }

  /// For a form-level problem caught before any Supabase call is even
  /// made (e.g. an empty field) — reuses the same error slot as a
  /// failed sign-in/sign-up so the UI only needs one error display.
  void reportValidationError(String message) {
    state = AuthFormState(errorMessage: message);
  }

  /// Doesn't navigate anywhere itself — clearing the Supabase session
  /// updates `isSignedInProvider` (core/auth/auth_gate.dart), and the
  /// router's own redirect sends a signed-out user back to Onboarding
  /// (ADR-0008). Callers may still navigate explicitly too, same
  /// belt-and-suspenders reasoning as AuthScreen's sign-in success
  /// handling.
  Future<void> signOut() async {
    state = const AuthFormState(isSubmitting: true);
    try {
      await Supabase.instance.client.auth.signOut();
      state = const AuthFormState();
    } on AuthException catch (error) {
      state = AuthFormState(errorMessage: error.message);
    } catch (_) {
      state = const AuthFormState(errorMessage: _genericErrorMessage);
    }
  }
}

const String _genericErrorMessage = 'Something went wrong. Please try again.';

final NotifierProvider<AuthController, AuthFormState> authControllerProvider =
    NotifierProvider<AuthController, AuthFormState>(AuthController.new);
