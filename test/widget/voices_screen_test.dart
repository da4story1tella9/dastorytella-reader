/// Exercises the real voice-fetching path (features/voices,
/// docs/adr/0009-real-voice-selection.md) against a stub `TTSClient`
/// subclass, same pattern as fake_auth_gate.dart — no real network
/// call to the backend or ElevenLabs.
library;

import 'package:dastorytella_reader/core/auth/auth_gate.dart';
import 'package:dastorytella_reader/core/tts/remote_voice.dart';
import 'package:dastorytella_reader/core/tts/tts_client.dart';
import 'package:dastorytella_reader/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_auth_gate.dart';

class _StubTTSClient extends TTSClient {
  _StubTTSClient({this.shouldFail = false});

  final bool shouldFail;

  @override
  Future<List<RemoteVoice>> listVoices() async {
    if (shouldFail) {
      throw const TTSRequestException('Voices are temporarily unavailable.');
    }
    return const <RemoteVoice>[
      RemoteVoice(
        voiceId: 'voice-a',
        name: 'Aria - Warm Narrator',
        category: 'premade',
        description: 'A warm narrator.',
        previewUrl: 'https://example.com/preview.mp3',
        labels: RemoteVoiceLabels(
          accent: 'british',
          useCase: 'narrative_story',
        ),
      ),
    ];
  }
}

Future<void> _pumpVoicesTab(
  WidgetTester tester, {
  required bool shouldFail,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        isSignedInProvider.overrideWith(FakeSignedInAuthGateController.new),
        ttsClientProvider.overrideWithValue(_StubTTSClient(shouldFail: shouldFail)),
      ],
      child: const DaStoryTellaReaderApp(),
    ),
  );
  await tester.pumpAndSettle();

  await tester.tap(find.text('Voices'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Voices screen shows real fetched voices', (
    WidgetTester tester,
  ) async {
    await _pumpVoicesTab(tester, shouldFail: false);

    expect(find.text('Aria'), findsOneWidget);
  });

  testWidgets('Voices screen shows an error with retry on failure', (
    WidgetTester tester,
  ) async {
    await _pumpVoicesTab(tester, shouldFail: true);

    expect(find.text('Voices are temporarily unavailable.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });
}
