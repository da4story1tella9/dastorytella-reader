/// Download manager state (see ADR-0004). The in-progress download's
/// progress genuinely ticks up on a timer and can be paused/resumed —
/// no real file transfer (ARCHITECTURE.md §4 doesn't exist yet), but
/// the interaction is real rather than a static mock.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/download_item.dart';
import '../models/download_status.dart';
import 'mock_download_data.dart';

class DownloadManagerController extends Notifier<List<DownloadItem>> {
  Timer? _ticker;

  @override
  List<DownloadItem> build() {
    ref.onDispose(() => _ticker?.cancel());
    final List<DownloadItem> initial = List.of(mockDownloadItems);
    if (initial.any(
      (DownloadItem d) => d.status == DownloadStatus.downloading,
    )) {
      _startTicking();
    }
    return initial;
  }

  void togglePause(String id) {
    final int index = state.indexWhere((DownloadItem d) => d.id == id);
    if (index == -1) {
      return;
    }
    final DownloadItem item = state[index];
    if (item.status == DownloadStatus.downloading) {
      _ticker?.cancel();
      state = _replaceAt(index, item.copyWith(status: DownloadStatus.paused));
    } else if (item.status == DownloadStatus.paused) {
      state = _replaceAt(
        index,
        item.copyWith(status: DownloadStatus.downloading),
      );
      _startTicking();
    }
  }

  void _startTicking() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      final int index = state.indexWhere(
        (DownloadItem d) => d.status == DownloadStatus.downloading,
      );
      if (index == -1) {
        timer.cancel();
        return;
      }
      final DownloadItem item = state[index];
      // Slow enough (~25s from a 64% start) to actually interact with
      // pause/resume before it auto-completes — a faster tick looked
      // fine in code but finished before anyone could touch it.
      final double nextProgress = (item.progress + 0.015).clamp(0.0, 1.0);
      if (nextProgress >= 1.0) {
        timer.cancel();
        state = _replaceAt(
          index,
          item.copyWith(
            status: DownloadStatus.ready,
            progress: 1,
            staticSubtitle: '${item.totalMb.round()} MB · downloaded just now',
          ),
        );
      } else {
        state = _replaceAt(index, item.copyWith(progress: nextProgress));
      }
    });
  }

  List<DownloadItem> _replaceAt(int index, DownloadItem item) {
    final List<DownloadItem> next = List.of(state);
    next[index] = item;
    return next;
  }
}

final NotifierProvider<DownloadManagerController, List<DownloadItem>>
    downloadItemsProvider =
    NotifierProvider<DownloadManagerController, List<DownloadItem>>(
  DownloadManagerController.new,
);
