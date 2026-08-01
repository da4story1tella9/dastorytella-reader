/// Hardcoded "now playing" sample, mirroring the Player screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// The book/chapter/transcript metadata is a placeholder until the TTS
/// pipeline (ARCHITECTURE.md §3) exists — no backend calls. Audio
/// playback itself is real (`just_audio`, see `NowPlayingController`),
/// backed by a bundled synthetic placeholder tone
/// (`assets/audio/sample_chapter.wav`) rather than real narration, since
/// no TTS-generated audio exists yet. Its duration (~30s) is much
/// shorter than the fictional "Chapter 3 of 18" story this mock data
/// describes — that mismatch is expected until real audio replaces it.
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
  audioAssetPath: 'assets/audio/sample_chapter.wav',
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
