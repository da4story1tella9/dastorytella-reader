import 'package:flutter/material.dart';

/// Display model for a library entry.
///
/// Backed by hardcoded sample data (see `state/mock_library_data.dart`)
/// until library sync (ARCHITECTURE.md §1) is wired up.
class Book {
  const Book({
    required this.id,
    required this.title,
    required this.byline,
    required this.spineLabel,
    required this.coverGradient,
    required this.progress,
    this.isDownloaded = false,
  });

  final String id;
  final String title;
  final String byline;

  /// Short label rendered on the cover art itself.
  final String spineLabel;
  final List<Color> coverGradient;

  /// Listening/reading progress, 0.0–1.0.
  final double progress;
  final bool isDownloaded;
}
