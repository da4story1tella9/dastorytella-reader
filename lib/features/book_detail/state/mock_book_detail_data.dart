/// Hardcoded book detail sample, mirroring
/// `docs/design-reference/app-mockups-core-batch1.html`.
///
/// Same book/cover as `core/playback/mock_now_playing_data.dart` (Le
/// Salon Caramel) — this is the one book with narrative-level mock
/// data, so every book card currently routes here regardless of
/// which one was tapped (see `book_detail_screen.dart`).
library;

import 'package:flutter/material.dart';

import '../models/chapter_summary.dart';

const String mockBookTitle = 'Le Salon Caramel';
const String mockBookByline = 'Read by Amara · 6h 40m total';
const List<Color> mockBookCoverGradient = <Color>[
  Color(0xFF8A3A3F),
  Color(0xFF4C1C20),
];
const int mockBookOverallProgressPercent = 38;
const int mockBookTotalChapters = 18;

const List<ChapterSummary> mockChapters = <ChapterSummary>[
  ChapterSummary(index: 1, title: 'The Rain in Abidjan', durationLabel: '22 min'),
  ChapterSummary(index: 2, title: "A Backbencher's Vow", durationLabel: '19 min'),
  ChapterSummary(index: 3, title: 'Le Salon Caramel', durationLabel: ''),
  ChapterSummary(index: 4, title: "The Vendor's Silence", durationLabel: '26 min'),
  ChapterSummary(index: 5, title: 'Aïssa Asks a Question', durationLabel: '31 min'),
  ChapterSummary(index: 6, title: 'VIP Section, Abuja', durationLabel: '24 min'),
  ChapterSummary(index: 7, title: 'Broken Glass', durationLabel: '18 min'),
];
