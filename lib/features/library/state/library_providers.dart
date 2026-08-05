/// Library screen state (see ADR-0004, ADR-0010).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/books/books_client.dart';
import '../../../core/books/remote_book.dart';
import '../models/book.dart';
import '../models/library_segment.dart';
import 'book_mapper.dart';

final StateProvider<LibrarySegment> librarySegmentProvider =
    StateProvider<LibrarySegment>((Ref ref) => LibrarySegment.saved);

class LibraryBooksController extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    final BooksClient client = ref.watch(booksClientProvider);
    final List<RemoteBook> remote = await client.listBooks();
    return remote.map(toUiBook).toList();
  }
}

/// Real for the Saved segment; Collections/Archive have no backend
/// concept yet (same gap as before this ADR — genuinely empty for
/// every user today, which is what makes the empty-state UI for those
/// segments reachable at all).
final AsyncNotifierProvider<LibraryBooksController, List<Book>>
libraryBooksProvider =
    AsyncNotifierProvider<LibraryBooksController, List<Book>>(
      LibraryBooksController.new,
    );
