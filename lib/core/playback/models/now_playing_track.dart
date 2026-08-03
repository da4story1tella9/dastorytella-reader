import 'package:flutter/material.dart';

import 'transcript_sentence.dart';

/// Display model for the currently-playing book/chapter.
///
/// Book/chapter/transcript metadata is backed by hardcoded sample
/// data (see `mock_now_playing_data.dart`) until real ingestion
/// (ARCHITECTURE.md §3) exists — but the audio itself is real, fetched
/// from the backend TTS proxy for this track's transcript text (see
/// `NowPlayingController`, docs/adr/0007-player-real-tts.md).
class NowPlayingTrack {
  const NowPlayingTrack({
    required this.bookTitle,
    required this.spineLabel,
    required this.coverGradient,
    required this.chapterIndex,
    required this.totalChapters,
    required this.voiceLabel,
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

  final List<TranscriptSentence> transcript;
  final bool isDownloaded;
}
