import 'package:flutter/material.dart';

import 'download_status.dart';

/// A single row in the Download manager — an in-progress download or
/// an already-downloaded book/voice.
class DownloadItem {
  const DownloadItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.status,
    this.progress = 0,
    this.totalMb = 0,
    this.staticSubtitle,
  });

  final String id;
  final IconData icon;
  final String title;
  final DownloadStatus status;

  /// 0.0–1.0. Only meaningful when [status] is downloading/paused —
  /// the subtitle is computed from this and [totalMb] at render time
  /// so it can't drift as progress ticks.
  final double progress;
  final double totalMb;

  /// Used directly for queued/ready rows, e.g. "Queued · waiting for
  /// Wi-Fi" or "58 MB · downloaded 2 days ago".
  final String? staticSubtitle;

  DownloadItem copyWith({
    DownloadStatus? status,
    double? progress,
    String? staticSubtitle,
  }) {
    return DownloadItem(
      id: id,
      icon: icon,
      title: title,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      totalMb: totalMb,
      staticSubtitle: staticSubtitle ?? this.staticSubtitle,
    );
  }
}
