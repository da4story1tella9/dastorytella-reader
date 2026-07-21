/// Saved / Collections / Archive switcher.
/// Mirrors `.segmented` in `docs/design-reference/app-mockups-v2.html`.
library;

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../models/library_segment.dart';

class LibrarySegmentedControl extends StatelessWidget {
  const LibrarySegmentedControl({
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final LibrarySegment selected;
  final ValueChanged<LibrarySegment> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            for (final LibrarySegment segment in LibrarySegment.values)
              Expanded(
                child: _Segment(
                  label: segment.label,
                  active: segment == selected,
                  onTap: () => onChanged(segment),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(11),
          boxShadow: active
              ? const <BoxShadow>[
                  BoxShadow(
                    color: Color(0x1A251D18),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTypography.bodyStrong.copyWith(
            fontSize: 12.5,
            color: active ? AppColors.ink : AppColors.inkSoft,
          ),
        ),
      ),
    );
  }
}
