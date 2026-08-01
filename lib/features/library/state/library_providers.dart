/// Library screen state (see ADR-0004).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/book.dart';
import '../models/library_segment.dart';
import 'mock_library_data.dart';

final StateProvider<LibrarySegment> librarySegmentProvider =
    StateProvider<LibrarySegment>((Ref ref) => LibrarySegment.saved);

/// Collections/Archive are genuinely empty for a new user in this mock
/// data — that's what makes the empty-library state (batch1 mockup)
/// reachable without a fake dev toggle.
final Provider<List<Book>> libraryBooksProvider = Provider<List<Book>>((
  Ref ref,
) {
  final LibrarySegment segment = ref.watch(librarySegmentProvider);
  return segment == LibrarySegment.saved ? mockBooks : const <Book>[];
});
