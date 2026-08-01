/// A single word → pronunciation override.
class PronunciationEntry {
  const PronunciationEntry({
    required this.word,
    required this.pronunciation,
    required this.contextLabel,
  });

  final String word;

  /// Phonetic respelling, e.g. "ah-EE-sah".
  final String pronunciation;

  /// Which book this applies to, or "Applies to all books".
  final String contextLabel;
}
