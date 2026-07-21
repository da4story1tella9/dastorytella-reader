import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Static "waveform" visualization — bar heights follow the same
/// sine/cosine formula as the JS generator in
/// `docs/design-reference/app-mockups-v2.html` (`buildWaveform`), so
/// the shape matches even though there's no real audio analysis yet.
class WaveformBars extends StatelessWidget {
  const WaveformBars({required this.playedFraction, super.key});

  final double playedFraction;

  static const int _barCount = 42;

  @override
  Widget build(BuildContext context) {
    final int playedBars = (_barCount * playedFraction).round();
    return SizedBox(
      height: 30,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (int i = 0; i < _barCount; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 2.5),
            Container(
              width: 3,
              height:
                  6 +
                  (math.sin(i * 0.5)).abs() * 18 +
                  (math.cos(i * 0.22)).abs() * 5,
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
