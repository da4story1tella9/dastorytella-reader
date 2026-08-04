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

    expect(find.text('Amara'), findsOneWidget);
    expect(find.text('Kwame'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Kelechi Omeire'), findsOneWidget);
  });
}
