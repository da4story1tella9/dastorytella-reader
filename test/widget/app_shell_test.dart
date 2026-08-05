import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dastorytella_reader/core/auth/auth_gate.dart';
import 'package:dastorytella_reader/main.dart';

import '../helpers/fake_auth_gate.dart';

void main() {
  testWidgets('boots to Library and bottom nav switches tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          isSignedInProvider.overrideWith(FakeSignedInAuthGateController.new),
        ],
        child: const DaStoryTellaReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsWidgets);

    await tester.tap(find.text('Voices'));
    await tester.pumpAndSettle();

    // Voices tab title, not specific voice content — the voice list
    // itself is real now (docs/adr/0009-real-voice-selection.md) and
    // correctly shows an error state here since there's no Supabase
    // session in the test environment; see voices_screen_test.dart
    // for coverage of both the success and failure states.
    expect(find.text('Voices'), findsWidgets);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Kelechi Omeire'), findsOneWidget);
  });
}
