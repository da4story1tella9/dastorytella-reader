/// Display model for the Storage settings row's usage bar.
class StorageStats {
  const StorageStats({
    required this.usedGb,
    required this.totalGb,
    required this.booksFraction,
    required this.voicesFraction,
  });

  final double usedGb;
  final double totalGb;

  /// Fraction (0.0–1.0) of the bar's full width used by books.
  final double booksFraction;

  /// Fraction (0.0–1.0) of the bar's full width used by voices.
  final double voicesFraction;
}
