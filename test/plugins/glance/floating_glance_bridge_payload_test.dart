import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/glance/data/platform/floating/method_channel_floating_glance_bridge.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_freshness.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_range_state.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_snapshot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channelName = 'test/floating_glance';
  const channel = MethodChannel(channelName);

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('floating glance update does not overwrite native drag position',
      () async {
    MethodCall? capturedCall;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      capturedCall = call;
      return true;
    });

    const bridge = MethodChannelFloatingGlanceBridge(
      channel: channel,
      platform: TargetPlatform.android,
    );

    await bridge.update(
      settings: const FloatingGlanceSettings(),
      snapshot: _snapshot(),
    );

    final arguments = capturedCall!.arguments as Map<Object?, Object?>;
    expect(capturedCall!.method, 'update');
    expect(arguments.containsKey('x'), isFalse);
    expect(arguments.containsKey('y'), isFalse);
    expect(arguments['valueLabel'], '7.2');
  });
}

GlanceSnapshot _snapshot() {
  final now = DateTime(2026, 1, 1, 12);
  return GlanceSnapshot(
    generatedAt: now,
    subjectId: 'self',
    latestReading: null,
    trendReadings: const [],
    unit: GlucoseUnit.mmolL,
    valueLabel: '7.2',
    alternateValueLabel: '130',
    unitLabel: 'mmol/L',
    deltaLabel: '+0.2',
    trendArrow: '\u2192',
    sourceLabel: 'Nightscout',
    freshness: GlanceFreshness.evaluate(updatedAt: now, now: now),
    rangeState: GlanceRangeState.inRange,
    targetLowMmol: 3.9,
    targetHighMmol: 10,
  );
}
