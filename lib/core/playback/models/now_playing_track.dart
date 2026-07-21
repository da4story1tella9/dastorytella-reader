import 'package:flutter/material.dart';

import 'transcript_sentence.dart';

/// Display model for the currently-playing book/chapter.
///
/// Backed by hardcoded sample data (see `mock_now_playing_data.dart`)
/// until the TTS pipeline (ARCHITECTURE.md §3) is wired up.
class NowPlayingTrack {
  const NowPlayingTrack({
    required this.bookTitle,
    required this.spineLabel,
    required this.coverGradient,
    required this.chapterIndex,
    required this.totalChapters,
    required this.voiceLabel,
    required this.durationSeconds,
    required this.transcript,
    required this.isDownloaded,
  });

  final String bookTitle;
  final String spineLabel;
  final List<Color> coverGradient;
  final int chapterIndex;
  final int totalChapters;

  /// e.g. "Amara — Warm Narrative"
  final String voiceLabel;
  final int durationSeconds;
  final List<TranscriptSentence> transcript;
  final bool isDownloaded;
}
