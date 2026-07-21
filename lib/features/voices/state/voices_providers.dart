/// Voices screen state (see ADR-0004).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/voice.dart';
import '../models/voice_category.dart';
import '../models/voice_explore_tab.dart';
import '../models/voices_segment.dart';
import 'mock_voices_data.dart';

final StateProvider<VoicesSegment> voicesSegmentProvider =
    StateProvider<VoicesSegment>((Ref ref) => VoicesSegment.all);

final StateProvider<VoiceExploreTab> voiceExploreTabProvider =
    StateProvider<VoiceExploreTab>((Ref ref) => VoiceExploreTab.explore);

final StateProvider<VoiceCategory> voiceCategoryProvider =
    StateProvider<VoiceCategory>((Ref ref) => VoiceCategory.narrativeAndStory);

final Provider<List<Voice>> voicesListProvider = Provider<List<Voice>>(
  (Ref ref) => mockVoices,
);
