import '../models/voice_sample.dart';

/// Two fixed demo excerpts shown for every voice, mirroring
/// `docs/design-reference/app-mockups-secondary-batch.html`'s
/// "Hear how it handles…" section.
///
/// Not real audio previews — there's no per-voice sample audio yet
/// (only the single placeholder tone driving `core/playback`), so
/// these play buttons are visual-only. See `VoiceDetailScreen`.
const List<VoiceSample> mockVoiceSamples = <VoiceSample>[
  VoiceSample(
    label: 'Punctuation & pacing',
    text: '"Wait —" she said, "you\'re leaving? Now? After everything?"',
  ),
  VoiceSample(
    label: 'Tonal range',
    text: 'The market was calm at dawn. By noon, it was chaos — shouting, '
        'bargaining, a stray dog barking at nothing.',
  ),
];
