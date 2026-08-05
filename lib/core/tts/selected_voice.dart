/// The user's currently selected narration voice — set via Voice
/// Detail's "Set as default" (docs/adr/0009-real-voice-selection.md).
/// In-memory only for now, resetting on app restart; there's no
/// per-user persisted preference yet (`ARCHITECTURE.md` §5's User
/// model isn't built).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ElevenLabs' "Rachel" voice — used until the user picks one, since
/// there's nothing else to default to yet.
const String defaultVoiceId = '21m00Tcm4TlvDq8ikWAM';

final StateProvider<String> selectedVoiceIdProvider = StateProvider<String>(
  (Ref ref) => defaultVoiceId,
);
