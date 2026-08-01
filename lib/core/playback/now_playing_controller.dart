/// Shared "now playing" controller (see ADR-0004). Drives real audio
/// playback via `just_audio` — see `mock_now_playing_data.dart` for why
/// that's currently a bundled placeholder tone rather than real
/// narration (the TTS pipeline, ARCHITECTURE.md §3, doesn't exist yet).
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

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
  late final AudioPlayer _player;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  NowPlayingState build() {
    _player = AudioPlayer();
    ref.onDispose(() {
      unawaited(_positionSub?.cancel());
      unawaited(_playerStateSub?.cancel());
      unawaited(_guard(_player.dispose));
    });

    unawaited(_initAudio());

    return NowPlayingState(
      track: mockNowPlayingTrack,
      isPlaying: false,
      positionSeconds: 0,
      durationSeconds: 0,
      speed: 1,
      isBookmarked: false,
      sleepTimerLabel: _sleepTimerPresets.first,
    );
  }

  /// Runs a `just_audio` call and swallows any failure — the plugin has
  /// no real platform backend in the `flutter test` environment (or on
  /// an unsupported platform), and a plugin hiccup shouldn't crash the
  /// shared playback state. UI falls back to inert 0:00/0:00 display.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      debugPrint('NowPlayingController: audio call failed — $error');
    }
  }

  Future<void> _initAudio() async {
    await _guard(() async {
      // Deliberately read the asset path from the top-level constant,
      // not `state.track.audioAssetPath` — this closure's synchronous
      // prefix (everything before the `await`) runs immediately when
      // `_initAudio` is called from `build()`, before `build()` has
      // returned, and `state` isn't readable yet at that point.
      final Duration? duration = await _player.setAsset(
        mockNowPlayingTrack.audioAssetPath,
      );
      // The write below only runs after the await, by which point
      // `state` is safe to touch — unless the provider was disposed
      // (e.g. a test's widget tree torn down) while it was in flight,
      // in which case this throws and `_guard` swallows it.
      if (duration != null) {
        state = state.copyWith(durationSeconds: duration.inSeconds);
      }
    });

    _positionSub = _player.positionStream.listen((Duration position) {
      state = state.copyWith(positionSeconds: position.inSeconds);
    });

    _playerStateSub = _player.playerStateStream.listen((
      PlayerState playerState,
    ) {
      state = state.copyWith(isPlaying: playerState.playing);
      if (playerState.processingState == ProcessingState.completed) {
        unawaited(_guard(_player.pause));
        unawaited(_guard(() => _player.seek(Duration.zero)));
      }
    });
  }

  void togglePlaying() {
    unawaited(_guard(state.isPlaying ? _player.pause : _player.play));
  }

  void skip(int deltaSeconds) {
    final int targetSeconds = (state.positionSeconds + deltaSeconds).clamp(
      0,
      state.durationSeconds,
    );
    unawaited(_guard(() => _player.seek(Duration(seconds: targetSeconds))));
  }

  void cycleSpeed() {
    final int i = AppConstants.playbackSpeeds.indexOf(state.speed);
    final int next = (i + 1) % AppConstants.playbackSpeeds.length;
    final double newSpeed = AppConstants.playbackSpeeds[next];
    unawaited(_guard(() => _player.setSpeed(newSpeed)));
    state = state.copyWith(speed: newSpeed);
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
