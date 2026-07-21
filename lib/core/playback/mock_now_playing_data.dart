/// Hardcoded "now playing" sample, mirroring the Player screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// Placeholder until the TTS pipeline (ARCHITECTURE.md §3) exists —
/// no backend calls.
library;

import 'package:flutter/material.dart';

import 'models/now_playing_track.dart';
import 'models/transcript_sentence.dart';

const NowPlayingTrack mockNowPlayingTrack = NowPlayingTrack(
  bookTitle: 'Le Salon Caramel',
  spineLabel: 'LE SALON\nCARAMEL',
  coverGradient: <Color>[Color(0xFF8A3A3F), Color(0xFF4C1C20)],
  chapterIndex: 3,
  totalChapters: 18,
  voiceLabel: 'Amara — Warm Narrative',
  durationSeconds: 38 * 60 + 7,
  isDownloaded: true,
  transcript: <TranscriptSentence>[
    TranscriptSentence(
      text:
          'The rain in Abidjan arrives without apology, sudden as a '
          'decision he never quite made. ',
      isActive: false,
    ),
    TranscriptSentence(
      text:
          "He ducked beneath the café's canvas awning, the city "
          'dissolving to a wash of headlights and wet asphalt. ',
      isActive: true,
    ),
    TranscriptSentence(
      text:
          'Inside, the smell of roasted coffee — and a woman named '
          'Aïssa, watching him from the counter.',
      isActive: false,
    ),
  ],
);

/// Matches the mockup's displayed elapsed time (left side of the
/// time-row, "14:22") — chosen over the alternative reading because it
/// lines up with the waveform's hand-set played-bar fraction (15/42 ≈
/// 0.36 there vs. 862/2287 ≈ 0.38 here). The mini-player's "X left"
/// label is then derived (duration − position) rather than copied as
/// a separate hardcoded string, so the two surfaces can't drift.
const int mockInitialPositionSeconds = 14 * 60 + 22;
