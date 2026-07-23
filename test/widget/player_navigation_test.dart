import 'package:dastorytella_reader/main.dart';
import 'package:dastorytella_reader/shared_widgets/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('mini-player opens Player screen and back returns to Library', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: DaStoryTellaReaderApp()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(MiniPlayer));
    await tester.pumpAndSettle();

    expect(find.text('Amara — Warm Narrative'), findsOneWidget);
    expect(find.text('Chapter 3'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.keyboard_arrow_down).first);
    await tester.pumpAndSettle();

    expect(find.text('Chapter 3'), findsNothing);
    expect(find.byType(MiniPlayer), findsOneWidget);
  });
}
