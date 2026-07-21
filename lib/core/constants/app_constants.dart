/// App-wide constants that aren't design tokens (those live in
/// `core/theme/`) and aren't environment/secrets (those belong in
/// env config, never committed — see `.gitignore`).
class AppConstants {
  AppConstants._();

  static const String appName = "daStoryTella's Reader";

  // Playback
  static const int skipSecondsShort = 15;
  static const List<double> playbackSpeeds = [0.75, 1.0, 1.25, 1.5, 1.75, 2.0];

  // Import
  static const List<String> supportedFormats = [
    'epub',
    'pdf',
    'docx',
    'txt',
  ];
}
