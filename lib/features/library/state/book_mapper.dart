/// Maps a raw backend `RemoteBook` (core/books/remote_book.dart) onto
/// the UI-facing `Book` model — see docs/adr/0010-import-a-real-book.md.
library;

import 'package:flutter/material.dart';

import '../../../core/books/remote_book.dart';
import '../models/book.dart';

// Same technique as the Voices feature's avatar-gradient mapping
// (features/voices/state/voice_mapper.dart) — a real book has no
// cover art yet (no cover-image ingestion exists), so one is assigned
// deterministically by book ID from a small fixed palette instead of
// always defaulting to the same color.
const List<List<Color>> _coverGradients = <List<Color>>[
  <Color>[Color(0xFF8A3A3F), Color(0xFF4C1C20)],
  <Color>[Color(0xFF3D5A4E), Color(0xFF1F3129)],
  <Color>[Color(0xFFC98A2E), Color(0xFF7A5218)],
  <Color>[Color(0xFF4A4266), Color(0xFF241F3D)],
];

Book toUiBook(RemoteBook remote) {
  final List<Color> gradient =
      _coverGradients[remote.id.hashCode.abs() % _coverGradients.length];

  return Book(
    id: remote.id,
    title: remote.title,
    // No voice-per-book assignment is persisted yet (ARCHITECTURE.md
    // §5's Book/Voice association isn't built) — a real, honest count
    // instead of a fabricated narrator name/style.
    byline: remote.chapters.length == 1
        ? '1 chapter'
        : '${remote.chapters.length} chapters',
    spineLabel: _spineLabel(remote.title),
    coverGradient: gradient,
    // No reading/listening position is persisted yet — 0.0 is the
    // honest starting value, not a placeholder standing in for
    // something else.
    progress: 0,
    isDownloaded: false,
  );
}

// The cover's spine text has no `maxLines`/overflow handling in
// BookCard, so a long title needs a short line break inserted rather
// than risking an overflow — same two-line style the mock covers use,
// just derived instead of hand-written per book.
String _spineLabel(String title) {
  final String upper = title.toUpperCase();
  final List<String> words = upper.split(' ');
  if (words.length < 2) {
    return upper;
  }
  final int midpoint = (words.length / 2).ceil();
  return '${words.sublist(0, midpoint).join(' ')}\n'
      '${words.sublist(midpoint).join(' ')}';
}
