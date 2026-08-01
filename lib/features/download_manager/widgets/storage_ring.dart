import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

/// Segmented storage-usage ring. Mirrors `.storage-ring`'s CSS
/// `conic-gradient` in
/// `docs/design-reference/app-mockups-secondary-batch.html`.
class StorageRing extends StatelessWidget {
  const StorageRing({
    required this.booksFraction,
    required this.voicesFraction,
    required this.centerLabel,
    super.key,
  });

  final double booksFraction;
  final double voicesFraction;
  final String centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size(56, 56),
            painter: _StorageRingPainter(
              booksFraction: booksFraction,
              voicesFraction: voicesFraction,
            ),
          ),
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Text(
              centerLabel,
              style: AppTypography.caption.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageRingPainter extends CustomPainter {
  _StorageRingPainter({
    required this.booksFraction,
    required this.voicesFraction,
  });

  final double booksFraction;
  final double voicesFraction;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    const double start = -math.pi / 2;

    void drawSegment(double fromFraction, double toFraction, Color color) {
      final double sweep = (toFraction - fromFraction) * 2 * math.pi;
      canvas.drawArc(
        rect,
        start + fromFraction * 2 * math.pi,
        sweep,
        true,
        Paint()..color = color,
      );
    }

    drawSegment(0, booksFraction, AppColors.maroon);
    drawSegment(
      booksFraction,
      booksFraction + voicesFraction,
      AppColors.gold,
    );
    drawSegment(booksFraction + voicesFraction, 1, AppColors.line);
  }

  @override
  bool shouldRepaint(_StorageRingPainter oldDelegate) {
    return oldDelegate.booksFraction != booksFraction ||
        oldDelegate.voicesFraction != voicesFraction;
  }
}
