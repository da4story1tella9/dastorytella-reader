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
  testWidgets('tapping a book card opens Book Detail and back returns', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          isSignedInProvider.overrideWith(FakeSignedInAuthGateController.new),
          booksClientProvider.overrideWithValue(FakeBooksClient()),
        ],
        child: const DaStoryTellaReaderApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BookCard).first);
    await tester.pumpAndSettle();

    expect(find.text('Read by Amara · 6h 40m total'), findsOneWidget);
    expect(find.text('The Rain in Abidjan'), findsOneWidget);
    // Chapter 3 ("Le Salon Caramel") is the currently-playing chapter,
    // so its row should show a live remaining-time label instead of
    // the static per-chapter duration.
    expect(find.textContaining('left of'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.text('Read by Amara · 6h 40m total'), findsNothing);
    expect(find.byType(BookCard), findsWidgets);
  });
}
