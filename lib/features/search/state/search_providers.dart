/// Search screen state (see ADR-0004). The query genuinely drives live
/// filtering below — see `SearchScreen` — not just local UI state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

final StateProvider<String> searchQueryProvider = StateProvider<String>(
  (Ref ref) => '',
);
