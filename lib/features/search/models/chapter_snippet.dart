/// A searchable excerpt from a chapter's transcript.
class ChapterSnippet {
  const ChapterSnippet({
    required this.bookTitle,
    required this.chapterLabel,
    required this.text,
  });

  final String bookTitle;
  final String chapterLabel;
  final String text;
}
