/// Test double for `BooksClient` (core/books/books_client.dart) —
/// widget tests that need at least one real-shaped book to render
/// (BookCard, MiniPlayer's visibility) override `booksClientProvider`
/// with this instead of hitting the real backend.
library;

import 'package:dastorytella_reader/core/books/books_client.dart';
import 'package:dastorytella_reader/core/books/remote_book.dart';
import 'package:dastorytella_reader/core/ingestion/parsed_book.dart';

class FakeBooksClient extends BooksClient {
  FakeBooksClient({List<RemoteBook>? books, this.shouldFail = false})
    : _books = books ?? _defaultBooks;

  final List<RemoteBook> _books;
  final bool shouldFail;

  @override
  Future<List<RemoteBook>> listBooks() async {
    if (shouldFail) {
      throw const BooksRequestException('Simulated failure loading books.');
    }
    return _books;
  }

  @override
  Future<RemoteBook> createBook({
    required String title,
    required List<ParsedChapter> chapters,
  }) async {
    throw UnimplementedError('Not used by tests using FakeBooksClient');
  }
}

final List<RemoteBook> _defaultBooks = <RemoteBook>[
  const RemoteBook(
    id: 'book-1',
    title: 'Test Book',
    createdAt: '2026-08-01T00:00:00Z',
    chapters: <RemoteChapter>[
      RemoteChapter(
        id: 'chap-1',
        index: 1,
        title: 'Chapter One',
        sentences: <String>['Hello there.'],
      ),
    ],
  ),
];
