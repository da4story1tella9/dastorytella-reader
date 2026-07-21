/// Saved / Collections / Archive switcher on the Library screen.
enum LibrarySegment { saved, collections, archive }

extension LibrarySegmentLabel on LibrarySegment {
  String get label {
    switch (this) {
      case LibrarySegment.saved:
        return 'Saved';
      case LibrarySegment.collections:
        return 'Collections';
      case LibrarySegment.archive:
        return 'Archive';
    }
  }
}
