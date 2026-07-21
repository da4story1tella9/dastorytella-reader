/// Shared "now playing" controller (see ADR-0004). No real audio
/// engine yet (ARCHITECTURE.md §3/§4) — play/pause and skip mutate
/// mock position state only, so the UI is interactive without a
/// backend to talk to.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import 'mock_now_playing_data.dart';
import 'now_playing_state.dart';

const List<String> _sleepTimerPresets = <String>[
  'Off',
  '15 min',
  '30 min',
  'End of chapter',
];

class NowPlayingController extends Notifier<NowPlayingState> {
  @override
  NowPlayingState build() {
    return NowPlayingState(
      track: mockNowPlayingTrack,
      isPlaying: false,
      positionSeconds: mockInitialPositionSeconds,
      speed: 1,
      isBookmarked: false,
      sleepTimerLabel: _sleepTimerPresets.first,
    );
  }

  void togglePlaying() {
    state = state.copyWith(isPlaying: !state.isPlaying);
  }

  void skip(int deltaSeconds) {
    final int next = (state.positionSeconds + deltaSeconds).clamp(
      0,
      state.track.durationSeconds,
    );
    state = state.copyWith(positionSeconds: next);
  }

  void cycleSpeed() {
    final int i = AppConstants.playbackSpeeds.indexOf(state.speed);
    final int next = (i + 1) % AppConstants.playbackSpeeds.length;
    state = state.copyWith(speed: AppConstants.playbackSpeeds[next]);
  }

  void toggleBookmark() {
    state = state.copyWith(isBookmarked: !state.isBookmarked);
  }

  void cycleSleepTimer() {
    final int i = _sleepTimerPresets.indexOf(state.sleepTimerLabel);
    final int next = (i + 1) % _sleepTimerPresets.length;
    state = state.copyWith(sleepTimerLabel: _sleepTimerPresets[next]);
  }
}

final NotifierProvider<NowPlayingController, NowPlayingState>
nowPlayingProvider = NotifierProvider<NowPlayingController, NowPlayingState>(
  NowPlayingController.new,
);
