/// Hardcoded sample dictionary entries, mirroring
/// `docs/design-reference/app-mockups-secondary-batch.html`.
///
/// Placeholder until pronunciation overrides (ARCHITECTURE.md §5,
/// `PronunciationEntry`) are backend-persisted — no backend calls.
library;

import '../models/pronunciation_entry.dart';

final List<PronunciationEntry> mockPronunciationEntries = <PronunciationEntry>[
  const PronunciationEntry(
    word: 'Aïssa',
    pronunciation: 'ah-EE-sah',
    contextLabel: 'Le Salon Caramel',
  ),
  const PronunciationEntry(
    word: 'Élias Koné',
    pronunciation: 'ay-lee-AHS koh-NAY',
    contextLabel: 'Blood of the Plateau',
  ),
  const PronunciationEntry(
    word: 'Germain Aka',
    pronunciation: 'zher-MAN ah-KAH',
    contextLabel: 'Blood of the Plateau',
  ),
  const PronunciationEntry(
    word: 'Abidjan',
    pronunciation: 'ah-bee-JAHN',
    contextLabel: 'Applies to all books',
  ),
  const PronunciationEntry(
    word: 'Inès',
    pronunciation: 'ee-NESS',
    contextLabel: 'Blood of the Plateau',
  ),
];
