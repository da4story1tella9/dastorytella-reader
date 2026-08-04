/// App-wide route table (see ADR-0005) and auth gate (ADR-0008).
///
/// Exposed as a Riverpod provider — consistent with ADR-0004 — rather
/// than a bare global, so it stays swappable/testable.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/models/auth_mode.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/book_detail/screens/book_detail_screen.dart';
import '../../features/download_manager/screens/download_manager_screen.dart';
import '../../features/library/screens/library_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/player/screens/player_screen.dart';
import '../../features/pronunciation_dictionary/screens/pronunciation_dictionary_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/voice_detail/screens/voice_detail_screen.dart';
import '../../features/voices/screens/voices_screen.dart';
import '../../shared_widgets/coming_soon_screen.dart';
import '../auth/auth_gate.dart';
import 'app_shell.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

// Reachable while signed out: the onboarding/sign-in/sign-up flow
// itself (obviously), plus the legal pages linked from its footer —
// Terms/Privacy must stay readable without an account.
const Set<String> _publicPaths = <String>{
  '/onboarding',
  '/sign-in',
  '/sign-up',
  '/terms',
  '/privacy-policy',
};

const Set<String> _authFlowPaths = <String>{
  '/onboarding',
  '/sign-in',
  '/sign-up',
};

/// Bridges `isSignedInProvider`'s Riverpod state to go_router's
/// `refreshListenable`, so a sign-in/sign-out re-evaluates `redirect`
/// immediately instead of only on the next explicit navigation.
class _AuthRefreshListenable extends ChangeNotifier {
  _AuthRefreshListenable(Ref ref) {
    ref.listen<bool>(isSignedInProvider, (bool? previous, bool next) {
      notifyListeners();
    });
  }
}

final Provider<GoRouter> appRouterProvider = Provider<GoRouter>((Ref ref) {
  final _AuthRefreshListenable refreshListenable = _AuthRefreshListenable(ref);
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/library',
    refreshListenable: refreshListenable,
    redirect: (BuildContext context, GoRouterState state) {
      final bool signedIn = ref.read(isSignedInProvider);
      final bool onPublicPath = _publicPaths.contains(state.matchedLocation);

      if (!signedIn && !onPublicPath) {
        return '/onboarding';
      }
      if (signedIn && _authFlowPaths.contains(state.matchedLocation)) {
        return '/library';
      }
      return null;
    },
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
      // Also root-level (see /player above) — reached from a Library
      // book card or the Player's chapter header, both full-screen
      // pushes with no bottom nav.
      GoRoute(
        path: '/book',
        builder: (BuildContext context, GoRouterState state) =>
            const BookDetailScreen(),
      ),
      // Also root-level (see /player above) — reached from a Voices
      // card tap.
      GoRoute(
        path: '/voice/:voiceId',
        builder: (BuildContext context, GoRouterState state) =>
            VoiceDetailScreen(voiceId: state.pathParameters['voiceId']!),
      ),
      // Also root-level (see /player above) — reached from Settings'
      // storage "Manage" link.
      GoRoute(
        path: '/downloads',
        builder: (BuildContext context, GoRouterState state) =>
            const DownloadManagerScreen(),
      ),
      // Also root-level (see /player above) — reached from Settings'
      // "Pronunciation dictionary" row.
      GoRoute(
        path: '/pronunciations',
        builder: (BuildContext context, GoRouterState state) =>
            const PronunciationDictionaryScreen(),
      ),
      // Also root-level (see /player above) — reached from the search
      // icon on Library and Voices.
      GoRoute(
        path: '/search',
        builder: (BuildContext context, GoRouterState state) =>
            const SearchScreen(),
      ),
      // Also root-level (see /player above). This IS the app's actual
      // startup gate now — see the `redirect` callback above and
      // OnboardingScreen's doc comment.
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingScreen(),
      ),
      // Also root-level (see /player above) — reached from Onboarding's
      // "Sign in" link.
      GoRoute(
        path: '/sign-in',
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(mode: AuthMode.signIn),
      ),
      // Also root-level (see /player above) — reached from Onboarding's
      // "Get started" and the sign-in screen's "Create an account"
      // link.
      GoRoute(
        path: '/sign-up',
        builder: (BuildContext context, GoRouterState state) =>
            const AuthScreen(mode: AuthMode.signUp),
      ),
      // Also root-level (see /player above) — reached from the auth
      // screens' footer. No real legal content yet — see
      // ComingSoonScreen.
      GoRoute(
        path: '/terms',
        builder: (BuildContext context, GoRouterState state) =>
            const ComingSoonScreen(title: 'Terms of Service'),
      ),
      GoRoute(
        path: '/privacy-policy',
        builder: (BuildContext context, GoRouterState state) =>
            const ComingSoonScreen(title: 'Privacy Policy'),
      ),
    ],
  );
});
