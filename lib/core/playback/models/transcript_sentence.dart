/// A single sentence in a chapter's transcript, for playback highlight.
///
/// Visually there are only two states — the currently-spoken sentence
/// and everything else — matching `.transcript-card` in
/// `docs/design-reference/app-mockups-v2.html` (`.past` and the
/// unclassed "upcoming" span render identically; only `.active` differs).
class TranscriptSentence {
  const TranscriptSentence({required this.text, required this.isActive});

  final String text;
  final bool isActive;
}
