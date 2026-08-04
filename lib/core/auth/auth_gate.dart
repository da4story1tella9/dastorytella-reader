/// Whether a Supabase session currently exists — drives the app-wide
/// auth gate (`core/router/app_router.dart`, ADR-0008). Reactive:
/// stays in sync with sign-in/sign-out via Supabase's own auth-state
/// stream, so the gate reacts immediately without needing an app
/// restart.
///
/// Degrades to "signed out" rather than throwing if Supabase was
/// never initialized — widget tests build the app directly without
/// calling `main()`, so `Supabase.initialize()` never runs there.
/// Tests that need a signed-in gate override this provider instead
/// (see `test/helpers/fake_auth_gate.dart`).
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGateController extends Notifier<bool> {
  StreamSubscription<AuthState>? _sub;

  @override
  bool build() {
    ref.onDispose(() => unawaited(_sub?.cancel()));

    try {
      final bool initiallySignedIn =
          Supabase.instance.client.auth.currentSession != null;
      _sub = Supabase.instance.client.auth.onAuthStateChange.listen((
        AuthState event,
      ) {
        state = event.session != null;
      });
      return initiallySignedIn;
    } catch (_) {
      return false;
    }
  }
}

final NotifierProvider<AuthGateController, bool> isSignedInProvider =
    NotifierProvider<AuthGateController, bool>(AuthGateController.new);
