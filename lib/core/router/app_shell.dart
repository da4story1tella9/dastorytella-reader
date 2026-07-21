/// Persistent bottom-nav shell for the Library / Voices / Settings tabs.
///
/// Each tab keeps its own navigation stack via [StatefulNavigationShell]
/// (see ADR-0005) — switching tabs doesn't reset scroll position or
/// push history within a tab.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared_widgets/app_bottom_nav.dart';

class AppShell extends StatelessWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
