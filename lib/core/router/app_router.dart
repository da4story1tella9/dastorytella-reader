/// App-wide route table (see ADR-0005).
///
/// Exposed as a Riverpod provider — consistent with ADR-0004 — rather
/// than a bare global, so it stays swappable/testable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/library/screens/library_screen.dart';
import '../../features/player/screens/player_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/voices/screens/voices_screen.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/library',
    routes: <RouteBase>[
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/library',
                builder: (BuildContext context, GoRouterState state) =>
                    const LibraryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/voices',
                builder: (BuildContext context, GoRouterState state) =>
                    const VoicesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: '/settings',
                builder: (BuildContext context, GoRouterState state) =>
                    const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      // Pushed on the root navigator (a sibling of the shell route, not
      // nested in a branch) so it covers the bottom nav entirely,
      // matching the mockup's full-screen Player.
      GoRoute(
        path: '/player',
        builder: (BuildContext context, GoRouterState state) =>
            const PlayerScreen(),
      ),
    ],
  );
});
