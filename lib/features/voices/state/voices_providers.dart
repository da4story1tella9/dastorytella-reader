/// Voices screen state (see ADR-0004, ADR-0009).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/tts/remote_voice.dart';
import '../../../core/tts/tts_client.dart';
import '../models/voice.dart';
import '../models/voice_category.dart';
import '../models/voice_explore_tab.dart';
import '../models/voices_segment.dart';
import 'voice_mapper.dart';

final StateProvider<VoicesSegment> voicesSegmentProvider =
    StateProvider<VoicesSegment>((Ref ref) => VoicesSegment.all);

final StateProvider<VoiceExploreTab> voiceExploreTabProvider =
    StateProvider<VoiceExploreTab>((Ref ref) => VoiceExploreTab.explore);

final StateProvider<VoiceCategory> voiceCategoryProvider =
    StateProvider<VoiceCategory>((Ref ref) => VoiceCategory.narrativeAndStory);

class VoicesController extends AsyncNotifier<List<Voice>> {
  @override
  Future<List<Voice>> build() async {
    final TTSClient client = ref.watch(ttsClientProvider);
    final List<RemoteVoice> remote = await client.listVoices();
    return remote.map(toUiVoice).toList();
  }
}

final AsyncNotifierProvider<VoicesController, List<Voice>> voicesListProvider =
    AsyncNotifierProvider<VoicesController, List<Voice>>(VoicesController.new);
