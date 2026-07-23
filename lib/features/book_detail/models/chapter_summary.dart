/// One entry in a book's chapter list. Done/current/upcoming status
/// isn't stored here — it's derived by comparing [index] against the
/// shared now-playing state's current chapter (see `ChapterRow`), so
/// the list can never disagree with what's actually playing.
class ChapterSummary {
  const ChapterSummary({
    required this.index,
    required this.title,
    required this.durationLabel,
  });

  final int index;
  final String title;

  /// e.g. "22 min" for an unplayed chapter. The currently-playing
  /// chapter's row overrides this with a live "X left of Y" label
  /// instead (see `ChapterRow`).
  final String durationLabel;
}
