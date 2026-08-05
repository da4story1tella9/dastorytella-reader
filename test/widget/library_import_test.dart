/// Exercises the real book-fetching path (features/library,
/// docs/adr/0010-import-a-real-book.md) against a stub `BooksClient`
/// subclass, same pattern as fake_auth_gate.dart/fake_books_client.dart
/// — no real network call to the backend.
library;

import 'package:dastorytella_reader/core/auth/auth_gate.dart';
import 'package:dastorytella_reader/core/books/books_client.dart';
import 'package:dastorytella_reader/core/books/remote_book.dart';
import 'package:dastorytella_reader/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_gate.dart';
import '../helpers/fake_books_client.dart';

Future<void> _pumpLibrary(
  WidgetTester tester, {
  required FakeBooksClient booksClient,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        isSignedInProvider.overrideWith(FakeSignedInAuthGateController.new),
        booksClientProvider.overrideWithValue(booksClient),
      ],
      child: const DaStoryTellaReaderApp(),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Library shows real fetched books', (WidgetTester tester) async {
    await _pumpLibrary(tester, booksClient: FakeBooksClient());

    expect(find.text('Test Book'), findsOneWidget);
    expect(find.text('1 chapter'), findsOneWidget);
  });

  testWidgets('Library shows an error with retry when fetching fails', (
    WidgetTester tester,
  ) async {
    await _pumpLibrary(
      tester,
      booksClient: FakeBooksClient(shouldFail: true),
    );

    expect(find.text('Simulated failure loading books.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'Library shows the empty state with an import CTA when there are no books',
    (WidgetTester tester) async {
      await _pumpLibrary(
        tester,
        booksClient: FakeBooksClient(books: const <RemoteBook>[]),
      );

      expect(find.text('Your library is empty'), findsOneWidget);
      expect(find.text('Import your first book'), findsOneWidget);
    },
  );
}
