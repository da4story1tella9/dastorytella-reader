/// Back-15 / play-pause / forward-15 transport controls. Mirrors
/// `.controls-labeled` in `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    required this.isPlaying,
    required this.onSkipBack,
    required this.onTogglePlaying,
    required this.onSkipForward,
    super.key,
  });

  final bool isPlaying;
  final VoidCallback onSkipBack;
  final VoidCallback onTogglePlaying;
  final VoidCallback onSkipForward;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _LabeledControl(
          label: 'Back 15',
          onTap: onSkipBack,
          child: const Icon(Icons.replay, size: 20, color: AppColors.ink),
        ),
        const SizedBox(width: 30),
        InkWell(
          onTap: onTogglePlaying,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 26,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 30),
        _LabeledControl(
          label: 'Fwd 15',
          onTap: onSkipForward,
          child: Transform.flip(
            flipX: true,
            child: const Icon(Icons.replay, size: 20, color: AppColors.ink),
          ),
        ),
      ],
    );
  }
}

class _LabeledControl extends StatelessWidget {
  const _LabeledControl({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            child,
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTypography.caption.copyWith(
                color: AppColors.inkSoft,
                fontSize: 9.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
