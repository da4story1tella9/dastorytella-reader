import 'package:dastorytella_reader/core/auth/auth_gate.dart';
import 'package:dastorytella_reader/core/books/books_client.dart';
import 'package:dastorytella_reader/features/library/widgets/book_card.dart';
import 'package:dastorytella_reader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_gate.dart';
import '../helpers/fake_books_client.dart';

void main() {
  testWidgets(
    'tapping a book card opens the real Book Detail and back returns',
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

      await tester.tap(find.byType(BookCard).first);
      await tester.pumpAndSettle();

      // Real data from FakeBooksClient's default book, not mock
      // strings — proves the screen actually fetched by the tapped
      // book's real id rather than showing fixed content regardless.
      expect(find.text('Test Book'), findsOneWidget);
      expect(find.text('1 chapter'), findsOneWidget);
      expect(find.text('Chapter One'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // 'Chapter One' — the chapter row — is unique to Book Detail;
      // 'Test Book'/'1 chapter' legitimately also appear on Library's
      // BookCard (same derived byline), so aren't useful here.
      expect(find.text('Chapter One'), findsNothing);
      expect(find.byType(BookCard), findsWidgets);
    },
  );
}
