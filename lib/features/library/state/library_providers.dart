/// Library screen state (see ADR-0004).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/book.dart';
import '../models/library_segment.dart';
import 'mock_library_data.dart';

final StateProvider<LibrarySegment> librarySegmentProvider =
    StateProvider<LibrarySegment>((Ref ref) => LibrarySegment.saved);

final Provider<List<Book>> libraryBooksProvider = Provider<List<Book>>(
  (Ref ref) => mockBooks,
);
