/// The user's currently selected narration voice — set via Voice
/// Detail's "Set as default" (docs/adr/0009-real-voice-selection.md).
/// In-memory only for now, resetting on app restart; there's no
/// per-user persisted preference yet (`ARCHITECTURE.md` §5's User
/// model isn't built).
///
/// Carries both id and name — `NowPlayingController`
/// (docs/adr/0011-real-book-detail.md) needs a human-readable label
/// for the Player screen, and resolving that from just an id would
/// mean `core/playback` reaching into `features/voices` to look it
/// up, an inverted (feature-depending-on-by-core) dependency this
/// avoids by storing the name alongside the id at selection time,
/// when the caller already has it in hand.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedVoice {
  const SelectedVoice({required this.id, required this.name});

  final String id;
  final String name;
}

/// ElevenLabs' "Rachel" voice — used until the user picks one, since
/// there's nothing else to default to yet.
const SelectedVoice defaultSelectedVoice = SelectedVoice(
  id: '21m00Tcm4TlvDq8ikWAM',
  name: 'Rachel',
);

final StateProvider<SelectedVoice> selectedVoiceProvider =
    StateProvider<SelectedVoice>((Ref ref) => defaultSelectedVoice);
