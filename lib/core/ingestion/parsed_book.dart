/// Raw shape of a parsed book as returned by the backend's `POST
/// /ingestion/parse` — see docs/adr/0010-import-a-real-book.md. A
/// direct mirror of the backend's `ParsedBook`/`ParsedChapter`
/// schemas — nothing has been saved yet at this point, this is just
/// what got parsed out of the uploaded file.
library;

class ParsedChapter {
  const ParsedChapter({
    required this.index,
    required this.title,
    required this.sentences,
  });

  factory ParsedChapter.fromJson(Map<String, dynamic> json) {
    return ParsedChapter(
      index: json['index'] as int,
      title: json['title'] as String,
      sentences: (json['sentences'] as List<dynamic>).cast<String>(),
    );
  }

  final int index;
  final String title;
  final List<String> sentences;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'index': index,
    'title': title,
    'sentences': sentences,
  };
}

class ParsedBook {
  const ParsedBook({required this.title, required this.chapters});

  factory ParsedBook.fromJson(Map<String, dynamic> json) {
    return ParsedBook(
      title: json['title'] as String,
      chapters: (json['chapters'] as List<dynamic>)
          .map((dynamic c) => ParsedChapter.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  final String title;
  final List<ParsedChapter> chapters;
}
