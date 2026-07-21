/// Formats a duration in seconds as `m:ss` (e.g. 862 → "14:22").
String formatMinutesSeconds(int totalSeconds) {
  final int minutes = totalSeconds ~/ 60;
  final int seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}
