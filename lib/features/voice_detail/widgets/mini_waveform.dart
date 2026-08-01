import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Small static waveform for a voice sample card — bar heights follow
/// the same formula as the JS generator (`buildMini`) in
/// `docs/design-reference/app-mockups-secondary-batch.html`. Purely
/// decorative (see `mock_voice_samples.dart` — no real per-sample
/// audio exists), toggled by [played].
class MiniWaveform extends StatelessWidget {
  const MiniWaveform({required this.played, super.key});

  final bool played;

  static const int _barCount = 34;

  @override
  Widget build(BuildContext context) {
    final int playedBars = played ? (_barCount * 0.35).round() : 0;
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < _barCount; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 2),
            Container(
              width: 2.5,
              height: 4 + (math.sin(i * 0.6)).abs() * 13,
              decoration: BoxDecoration(
                color: i < playedBars ? AppColors.gold : AppColors.line,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
