/// Exercises the real AuthGateController (core/auth/auth_gate.dart),
/// not a fake — no ProviderScope overrides here, deliberately. In the
/// widget-test environment Supabase is never initialized (no test
/// calls main()), which the controller treats as "signed out" — this
/// proves the app actually gates on that rather than just asserting
/// it in isolation.
library;

import 'package:dastorytella_reader/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('signed-out user lands on Onboarding, not Library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: DaStoryTellaReaderApp()),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Every book,\nread the way it deserves.'),
      findsOneWidget,
    );
    expect(find.text('Library'), findsNothing);
  });
}
