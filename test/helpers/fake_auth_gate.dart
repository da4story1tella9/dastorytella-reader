/// Test double for `AuthGateController` (core/auth/auth_gate.dart) —
/// widget tests that need to exercise signed-in-only screens
/// (Library, Player, Book Detail, ...) override `isSignedInProvider`
/// with this instead of relying on the real controller, which
/// degrades to "signed out" whenever Supabase isn't initialized (as
/// in every widget test, since none of them call `main()`).
library;

import 'package:dastorytella_reader/core/auth/auth_gate.dart';

class FakeSignedInAuthGateController extends AuthGateController {
  @override
  bool build() => true;
}
