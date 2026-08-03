/// Hardcoded "now playing" sample, mirroring the Player screen in
/// `docs/design-reference/app-mockups-v2.html`.
///
/// The book/chapter/transcript metadata is a placeholder until real
/// ingestion (ARCHITECTURE.md §3) exists — no backend calls for that
/// part yet. Audio is real, though: `NowPlayingController` synthesizes
/// this transcript's text via the backend TTS proxy on load (see
/// docs/adr/0007-player-real-tts.md) rather than playing a bundled
/// file.
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
