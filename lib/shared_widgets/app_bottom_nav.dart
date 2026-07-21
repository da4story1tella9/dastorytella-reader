/// Bottom tab bar shared by the Library / Voices / Settings shell.
///
/// Mirrors `.bottom-nav` / `.nav-item` in
/// `docs/design-reference/app-mockups-v2.html` (mockup nav also has a
/// centered add-FAB and a Stats tab; this build scopes the shell to the
/// three requested destinations only).
library;

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

class AppBottomNavItem {
  const AppBottomNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<AppBottomNavItem> items = <AppBottomNavItem>[
    AppBottomNavItem(icon: Icons.menu_book_outlined, label: 'Library'),
    AppBottomNavItem(icon: Icons.record_voice_over_outlined, label: 'Voices'),
    AppBottomNavItem(icon: Icons.settings_outlined, label: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              for (int i = 0; i < items.length; i++)
                _NavItem(
                  item: items[i],
                  active: i == currentIndex,
                  onTap: () => onTap(i),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = active ? AppColors.maroon : AppColors.inkFaint;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(item.icon, size: 20, color: color),
            const SizedBox(height: 3),
            Text(
              item.label,
              style: AppTypography.caption.copyWith(color: color, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
