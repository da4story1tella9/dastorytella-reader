/// Player-screen-only UI state — not shared with the mini-player (see
/// ADR-0004). Playback itself lives in `core/playback/`.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/player_tab.dart';

final StateProvider<PlayerTab> playerTabProvider = StateProvider<PlayerTab>(
  (Ref ref) => PlayerTab.listen,
);
