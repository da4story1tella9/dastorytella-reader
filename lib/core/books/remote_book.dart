/// Raw shape of a persisted book as returned by the backend's
/// `/books` routes — see docs/adr/0010-import-a-real-book.md and the
/// backend repo's docs/adr/0009-books-persistence.md. A direct mirror
/// of the backend's `Book`/`Chapter` schemas.
library;

class RemoteChapter {
  const RemoteChapter({
    required this.id,
    required this.index,
    required this.title,
    required this.sentences,
  });

  factory RemoteChapter.fromJson(Map<String, dynamic> json) {
    return RemoteChapter(
      id: json['id'] as String,
      index: json['index'] as int,
      title: json['title'] as String,
      sentences: (json['sentences'] as List<dynamic>).cast<String>(),
    );
  }

  final String id;
  final int index;
  final String title;
  final List<String> sentences;
}

class RemoteBook {
  const RemoteBook({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.chapters,
  });

  factory RemoteBook.fromJson(Map<String, dynamic> json) {
    return RemoteBook(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: json['created_at'] as String,
      chapters: (json['chapters'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic c) => RemoteChapter.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String title;
  final String createdAt;
  final List<RemoteChapter> chapters;
}
