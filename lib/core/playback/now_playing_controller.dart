/// Shared "now playing" controller (see ADR-0004). Drives real audio
/// playback via `just_audio`, loaded from the backend TTS proxy rather
/// than a bundled placeholder — see docs/adr/0007-player-real-tts.md.
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../tts/tts_client.dart';
import 'mock_now_playing_data.dart';
import 'models/transcript_sentence.dart';
import 'now_playing_state.dart';

const List<String> _sleepTimerPresets = <String>[
  'Off',
  '15 min',
  '30 min',
  'End of chapter',
];

// ElevenLabs' free API tier rejects its own shared library voices
// (see docs/adr/0007-player-real-tts.md) — this is a placeholder
// until a real, API-eligible voice exists. Every request correctly
// fails with a visible error until then, rather than silently
// substituting different audio.
const String _placeholderVoiceId = '21m00Tcm4TlvDq8ikWAM';

class NowPlayingController extends Notifier<NowPlayingState> {
  late final AudioPlayer _player;
  late final TTSClient _ttsClient;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  NowPlayingState build() {
    _player = AudioPlayer();
    _ttsClient = TTSClient();
    ref.onDispose(() {
      unawaited(_positionSub?.cancel());
      unawaited(_playerStateSub?.cancel());
      unawaited(_guard(_player.dispose));
    });

    // Subscriptions are set up once, here — not inside `_loadAudio`,
    // which also runs on retry and would otherwise leak a duplicate
    // subscription each time. Registering `.listen(...)` is itself
    // synchronous and doesn't touch `state`, so — unlike reading
    // `state` before `build()` returns — this is safe to do directly.
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

    unawaited(_loadAudio());

    return NowPlayingState(
      track: mockNowPlayingTrack,
      isPlaying: false,
      positionSeconds: 0,
      durationSeconds: 0,
      speed: 1,
      isBookmarked: false,
      sleepTimerLabel: _sleepTimerPresets.first,
      isLoadingAudio: true,
      loadErrorMessage: null,
    );
  }

  /// Runs a `just_audio` call and swallows any failure — used only
  /// for playback controls (play/pause/seek/speed), where "there's no
  /// audio loaded" is an uninteresting no-op (the load error, if any,
  /// is already visible via `loadErrorMessage`), not a fresh error
  /// worth surfacing again.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
    } catch (error) {
      debugPrint('NowPlayingController: audio call failed — $error');
    }
  }

  /// Constructs a new state around a change to the audio-loading
  /// fields specifically — not via [NowPlayingState.copyWith], whose
  /// nullable-field handling can't distinguish "leave the error
  /// message as-is" from "clear it" (see that class's doc comment).
  NowPlayingState _withLoadState({
    required bool isLoading,
    String? errorMessage,
    int? durationSeconds,
  }) {
    return NowPlayingState(
      track: state.track,
      isPlaying: state.isPlaying,
      positionSeconds: state.positionSeconds,
      durationSeconds: durationSeconds ?? state.durationSeconds,
      speed: state.speed,
      isBookmarked: state.isBookmarked,
      sleepTimerLabel: state.sleepTimerLabel,
      isLoadingAudio: isLoading,
      loadErrorMessage: errorMessage,
    );
  }

  Future<void> _loadAudio() async {
    // Deliberately built from the top-level mock constant, not
    // `state.track` — this function's synchronous prefix (everything
    // before its first `await`) runs immediately when called from
    // `build()`, before `build()` has returned, and `state` isn't
    // readable yet at that point.
    final String text = mockNowPlayingTrack.transcript
        .map((TranscriptSentence sentence) => sentence.text)
        .join();

    Duration? duration;
    String? errorMessage;
    try {
      final Uint8List audioBytes = await _ttsClient.synthesize(
        text: text,
        voiceId: _placeholderVoiceId,
      );
      final Directory tempDir = await getTemporaryDirectory();
      final File audioFile = File('${tempDir.path}/now_playing.mp3');
      await audioFile.writeAsBytes(audioBytes, flush: true);
      duration = await _player.setFilePath(audioFile.path);
    } on TTSRequestException catch (error) {
      errorMessage = error.message;
    } catch (error) {
      // Covers just_audio failing to decode the response, temp-file
      // IO failure, or a disposed provider mid-flight (e.g. a test's
      // widget tree torn down) — all treated the same as any other
      // load failure rather than crashing.
      debugPrint('NowPlayingController: audio load failed — $error');
      errorMessage = 'Something went wrong loading this chapter.';
    }

    state = _withLoadState(
      isLoading: false,
      errorMessage: errorMessage,
      durationSeconds: duration?.inSeconds,
    );
  }

  Future<void> retryLoadAudio() async {
    state = _withLoadState(isLoading: true);
    await _loadAudio();
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
