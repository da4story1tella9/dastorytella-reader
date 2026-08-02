/// Hardcoded searchable chapter excerpts, mirroring
/// `docs/design-reference/app-mockups-core-batch2.html`.
///
/// Placeholder until real full-text search over parsed chapters
/// (ARCHITECTURE.md §3) exists — no backend calls. Not the same text
/// as the Player's live transcript (`core/playback`) — that's one
/// specific in-progress sentence, this is a small illustrative
/// search corpus spanning a couple of chapters/books.
library;

import '../models/chapter_snippet.dart';

const List<ChapterSnippet> mockChapterSnippets = <ChapterSnippet>[
  ChapterSnippet(
    bookTitle: 'Le Salon Caramel',
    chapterLabel: 'Chapter 1',
    text: 'He passed the salon twice before the rain gave him a reason to '
        'go in.',
  ),
  ChapterSnippet(
    bookTitle: 'Le Salon Caramel',
    chapterLabel: 'Chapter 3',
    text: 'Inside, the salon smelled of roasted coffee, and a woman named '
        'Aïssa watched him from the counter.',
  ),
  ChapterSnippet(
    bookTitle: 'Blood of the Plateau',
    chapterLabel: 'Chapter 4',
    text: 'Germain Aka lit a cigarette in the dark, waiting for Élias to '
        'answer.',
  ),
];
