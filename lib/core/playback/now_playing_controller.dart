/// Shared "now playing" controller (see ADR-0004). Drives real audio
/// playback via `just_audio`, loaded from the backend TTS proxy rather
/// than a bundled placeholder — see docs/adr/0007-player-real-tts.md,
/// docs/adr/0009-real-voice-selection.md (voice choice), and
/// docs/adr/0011-real-book-detail.md (real book/chapter content —
/// nothing plays until `playChapter` is called with a real
/// selection; there's no eager mock load on startup).
library;

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';
import '../tts/selected_voice.dart';
import '../tts/tts_client.dart';
import 'models/now_playing_track.dart';
import 'models/transcript_sentence.dart';
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

    // Registering `.listen(...)` is itself synchronous and doesn't
    // touch `state`, so — unlike reading `state` before `build()`
    // returns — this is safe to do directly here, once, rather than
    // inside `_loadAudio` (which also runs on retry/a new chapter and
    // would otherwise leak a duplicate subscription each time).
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

    // No eager synthesis on startup — deliberate. Every previous
    // version of this controller loaded a track the moment the app
    // opened, which was fine for a bundled placeholder tone but means
    // a real ElevenLabs call (real cost, real rate-limit budget) on
    // every single app launch regardless of whether the user ever
    // opens the Player. Now nothing plays until `playChapter` is
    // called with something the user actually chose.
    return NowPlayingState(
      track: NowPlayingTrack.empty,
      isPlaying: false,
      positionSeconds: 0,
      durationSeconds: 0,
      speed: 1,
      isBookmarked: false,
      sleepTimerLabel: _sleepTimerPresets.first,
      isLoadingAudio: false,
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

  /// Starts playing a real chapter — called from Book Detail
  /// (docs/adr/0011-real-book-detail.md) with an actual persisted
  /// book/chapter, never mock data.
  Future<void> playChapter({
    required String bookId,
    required String bookTitle,
    required String spineLabel,
    required List<Color> coverGradient,
    required int chapterIndex,
    required int totalChapters,
    required List<String> sentences,
    required bool isDownloaded,
  }) async {
    final SelectedVoice voice = ref.read(selectedVoiceProvider);

    state = NowPlayingState(
      track: NowPlayingTrack(
        bookId: bookId,
        bookTitle: bookTitle,
        spineLabel: spineLabel,
        coverGradient: coverGradient,
        chapterIndex: chapterIndex,
        totalChapters: totalChapters,
        voiceLabel: voice.name,
        transcript: sentences
            .map(
              (String text) => TranscriptSentence(text: text, isActive: false),
            )
            .toList(),
        isDownloaded: isDownloaded,
      ),
      isPlaying: false,
      positionSeconds: 0,
      durationSeconds: 0,
      speed: state.speed, // keep the user's chosen speed across chapters
      isBookmarked: false,
      sleepTimerLabel: state.sleepTimerLabel,
      isLoadingAudio: true,
      loadErrorMessage: null,
    );

    await _loadAudio();
  }

  Future<void> _loadAudio() async {
    final String text = state.track.transcript
        .map((TranscriptSentence sentence) => sentence.text)
        .join();

    // Read once at load time, not watched — this deliberately doesn't
    // make an already-loaded chapter reactively re-synthesize if the
    // user changes their default voice mid-session (see ADR-0009);
    // the new voice takes effect on the next chapter played.
    final String voiceId = ref.read(selectedVoiceProvider).id;
    final TTSClient ttsClient = ref.read(ttsClientProvider);

    Duration? duration;
    String? errorMessage;
    try {
      final Uint8List audioBytes = await ttsClient.synthesize(
        text: text,
        voiceId: voiceId,
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
