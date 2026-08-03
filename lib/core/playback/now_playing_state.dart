import 'models/now_playing_track.dart';

/// Shared "now playing" state — read by both the Library mini-player
/// and the full Player screen so they never disagree about what's
/// playing (see ADR-0004).
class NowPlayingState {
  const NowPlayingState({
    required this.track,
    required this.isPlaying,
    required this.positionSeconds,
    required this.durationSeconds,
    required this.speed,
    required this.isBookmarked,
    required this.sleepTimerLabel,
    required this.isLoadingAudio,
    required this.loadErrorMessage,
  });

  final NowPlayingTrack track;
  final bool isPlaying;
  final int positionSeconds;

  /// Read from the real audio once loaded (see `NowPlayingController`)
  /// — 0 until then.
  final int durationSeconds;
  final double speed;
  final bool isBookmarked;
  final String sleepTimerLabel;

  /// True while this chapter's narration is being synthesized via the
  /// backend TTS proxy (see `NowPlayingController`,
  /// docs/adr/0007-player-real-tts.md) — no audio loaded yet.
  final bool isLoadingAudio;

  /// Set if synthesis failed — safe to show directly (see
  /// `TTSRequestException`). Null while loading or once loaded
  /// successfully; deliberately not settable via [copyWith] (see
  /// `NowPlayingController._withLoadState`), since a nullable field
  /// there can't distinguish "leave it as-is" from "clear it."
  final String? loadErrorMessage;

  int get remainingSeconds => durationSeconds - positionSeconds;

  NowPlayingState copyWith({
    bool? isPlaying,
    int? positionSeconds,
    int? durationSeconds,
    double? speed,
    bool? isBookmarked,
    String? sleepTimerLabel,
  }) {
    return NowPlayingState(
      track: track,
      isPlaying: isPlaying ?? this.isPlaying,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      speed: speed ?? this.speed,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      sleepTimerLabel: sleepTimerLabel ?? this.sleepTimerLabel,
      isLoadingAudio: isLoadingAudio,
      loadErrorMessage: loadErrorMessage,
    );
  }
}
