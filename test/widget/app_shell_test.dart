import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dastorytella_reader/main.dart';

void main() {
  testWidgets('boots to Library and bottom nav switches tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: DaStoryTellaReaderApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Library'), findsWidgets);

    await tester.tap(find.text('Voices'));
    await tester.pumpAndSettle();

    expect(find.text('Voice catalog coming soon.'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Settings coming soon.'), findsOneWidget);
  });
}
