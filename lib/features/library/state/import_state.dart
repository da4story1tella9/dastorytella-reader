/// UI state for the book-import flow (see ImportController).
library;

class ImportState {
  const ImportState({this.isImporting = false, this.errorMessage});

  final bool isImporting;

  /// A message safe to show directly — either the backend's own
  /// safe error message (via IngestionRequestException/
  /// BooksRequestException) or a generic fallback. Null while idle
  /// or importing, and once an import succeeds.
  final String? errorMessage;
}
