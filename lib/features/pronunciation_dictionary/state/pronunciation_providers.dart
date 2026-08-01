/// Pronunciation dictionary state (see ADR-0004). Genuinely mutable —
/// add/remove really change the list — unlike the mockup's static
/// "fake-input" fields, but not backend-persisted yet.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/pronunciation_entry.dart';
import 'mock_pronunciation_data.dart';

class PronunciationDictionaryController
    extends Notifier<List<PronunciationEntry>> {
  @override
  List<PronunciationEntry> build() => List.of(mockPronunciationEntries);

  void add(PronunciationEntry entry) {
    state = <PronunciationEntry>[...state, entry];
  }

  void removeAt(int index) {
    state = List.of(state)..removeAt(index);
  }
}

final NotifierProvider<PronunciationDictionaryController,
        List<PronunciationEntry>> pronunciationEntriesProvider =
    NotifierProvider<PronunciationDictionaryController,
        List<PronunciationEntry>>(PronunciationDictionaryController.new);
