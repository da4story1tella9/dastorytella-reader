import 'package:flutter/material.dart';

import 'transcript_sentence.dart';

/// Display model for the currently-playing book/chapter.
///
/// Real now — built by `NowPlayingController.playChapter` from an
/// actual persisted book/chapter (docs/adr/0011-real-book-detail.md),
/// not hardcoded mock data. [empty] is the inert placeholder before
/// anything has ever been played this session.
class NowPlayingTrack {
  const NowPlayingTrack({
    required this.bookId,
    required this.bookTitle,
    required this.spineLabel,
    required this.coverGradient,
    required this.chapterIndex,
    required this.totalChapters,
    required this.voiceLabel,
    required this.transcript,
    required this.isDownloaded,
  });

  /// Empty means "nothing has been played yet" — checked by
  /// MiniPlayer's callers to decide whether to show it at all, rather
  /// than showing a mini-player for a track nobody chose to play.
  static const NowPlayingTrack empty = NowPlayingTrack(
    bookId: '',
    bookTitle: '',
    spineLabel: '',
    coverGradient: <Color>[Color(0xFFEAE3D6), Color(0xFFEAE3D6)],
    chapterIndex: 0,
    totalChapters: 0,
    voiceLabel: '',
    transcript: <TranscriptSentence>[],
    isDownloaded: false,
  );

  final String bookId;
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
