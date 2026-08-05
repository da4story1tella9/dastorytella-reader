/// Book Detail screen state (see docs/adr/0011-real-book-detail.md).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/books/books_client.dart';
import '../../../core/books/remote_book.dart';

/// Null means not found — or, thanks to Postgres RLS on the backend,
/// belongs to someone else, indistinguishable from here (see
/// BooksClient.getBook).
final FutureProviderFamily<RemoteBook?, String> bookDetailProvider =
    FutureProvider.family<RemoteBook?, String>((Ref ref, String bookId) async {
      final BooksClient client = ref.watch(booksClientProvider);
      return client.getBook(id: bookId);
    });
