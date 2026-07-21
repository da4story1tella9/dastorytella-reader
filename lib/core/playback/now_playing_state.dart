import 'models/now_playing_track.dart';

/// Shared "now playing" state — read by both the Library mini-player
/// and the full Player screen so they never disagree about what's
/// playing (see ADR-0004).
class NowPlayingState {
  const NowPlayingState({
    required this.track,
    required this.isPlaying,
    required this.positionSeconds,
    required this.speed,
    required this.isBookmarked,
    required this.sleepTimerLabel,
  });

  final NowPlayingTrack track;
  final bool isPlaying;
  final int positionSeconds;
  final double speed;
  final bool isBookmarked;
  final String sleepTimerLabel;

  int get remainingSeconds => track.durationSeconds - positionSeconds;

  NowPlayingState copyWith({
    bool? isPlaying,
    int? positionSeconds,
    double? speed,
    bool? isBookmarked,
    String? sleepTimerLabel,
  }) {
    return NowPlayingState(
      track: track,
      isPlaying: isPlaying ?? this.isPlaying,
      positionSeconds: positionSeconds ?? this.positionSeconds,
      speed: speed ?? this.speed,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      sleepTimerLabel: sleepTimerLabel ?? this.sleepTimerLabel,
    );
  }
}
