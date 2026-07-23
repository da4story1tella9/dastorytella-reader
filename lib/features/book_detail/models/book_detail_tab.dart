/// Chapters / Bookmarks / Details switcher on the Book Detail screen.
enum BookDetailTab { chapters, bookmarks, details }

extension BookDetailTabLabel on BookDetailTab {
  String get label {
    switch (this) {
      case BookDetailTab.chapters:
        return 'Chapters';
      case BookDetailTab.bookmarks:
        return 'Bookmarks';
      case BookDetailTab.details:
        return 'Details';
    }
  }
}
