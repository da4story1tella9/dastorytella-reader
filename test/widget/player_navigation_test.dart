import 'package:dastorytella_reader/core/auth/auth_gate.dart';
import 'package:dastorytella_reader/core/books/books_client.dart';
import 'package:dastorytella_reader/features/library/widgets/book_card.dart';
import 'package:dastorytella_reader/main.dart';
import 'package:dastorytella_reader/shared_widgets/mini_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_gate.dart';
import '../helpers/fake_books_client.dart';

void main() {
  testWidgets(
    'tapping a chapter plays it, and the mini-player then reflects that',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: <Override>[
            isSignedInProvider.overrideWith(
              FakeSignedInAuthGateController.new,
            ),
            booksClientProvider.overrideWithValue(FakeBooksClient()),
          ],
          child: const DaStoryTellaReaderApp(),
        ),
      );
      await tester.pumpAndSettle();

      // Nothing has been played yet — the mini-player shouldn't
      // exist just because the library has a book (ADR-0011).
      expect(find.byType(MiniPlayer), findsNothing);

      await tester.tap(find.byType(BookCard).first);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chapter One'));
      await tester.pumpAndSettle();

      // On the Player screen now, for the real book/chapter — real
      // synthesis fails in this test environment (no Supabase
      // session), which the Player shows as an error banner rather
      // than crashing; still proves the real book/chapter loaded.
      expect(find.text('Test Book'), findsWidgets);

      await tester.tap(find.byIcon(Icons.keyboard_arrow_down).first);
      await tester.pumpAndSettle();

      // Back on Book Detail — the mini-player now shows, since
      // something real has actually been selected to play.
      expect(find.byType(MiniPlayer), findsOneWidget);
    },
  );
}
