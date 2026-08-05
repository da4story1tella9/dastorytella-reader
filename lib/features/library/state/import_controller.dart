/// Drives the "import a book" flow — pick a file, parse it (backend's
/// `/ingestion/parse`), save the result (`/books`), then refresh the
/// library. See docs/adr/0010-import-a-real-book.md.
library;

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/books/books_client.dart';
import '../../../core/ingestion/ingestion_client.dart';
import '../../../core/ingestion/parsed_book.dart';
import 'import_state.dart';
import 'library_providers.dart';

class ImportController extends Notifier<ImportState> {
  @override
  ImportState build() => const ImportState();

  /// Returns true on a successful import, false otherwise — including
  /// when the user simply cancelled the file picker, which isn't an
  /// error and shouldn't set `errorMessage`.
  Future<bool> pickAndImportBook() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>['epub'],
      withData: true, // needed for web; harmless elsewhere
    );
    if (result == null) {
      return false; // user cancelled — not an error
    }

    final PlatformFile file = result.files.single;
    final Uint8List? bytes = file.bytes;
    if (bytes == null) {
      state = const ImportState(
        errorMessage: "Couldn't read that file. Please try again.",
      );
      return false;
    }

    state = const ImportState(isImporting: true);
    try {
      final ParsedBook parsed = await ref
          .read(ingestionClientProvider)
          .parseEpub(bytes: bytes, filename: file.name);

      await ref
          .read(booksClientProvider)
          .createBook(title: parsed.title, chapters: parsed.chapters);

      state = const ImportState();
      ref.invalidate(libraryBooksProvider);
      return true;
    } on IngestionRequestException catch (error) {
      state = ImportState(errorMessage: error.message);
      return false;
    } on BooksRequestException catch (error) {
      state = ImportState(errorMessage: error.message);
      return false;
    } catch (_) {
      state = const ImportState(
        errorMessage: 'Something went wrong importing this book.',
      );
      return false;
    }
  }
}

final NotifierProvider<ImportController, ImportState> importControllerProvider =
    NotifierProvider<ImportController, ImportState>(ImportController.new);
