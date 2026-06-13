import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/platform_runtime/platform_runtime.dart';
import 'package:smart_xdrip/application/platform_runtime/platform_runtime_capability_snapshot.dart';

void main() {
  test('Android capability keeps local xDrip and continuous background sync',
      () {
    const snapshot = PlatformRuntimeCapabilitySnapshot.android();

    expect(snapshot.platform, PlatformRuntime.android);
    expect(snapshot.sync.supportsNightscoutApi, isTrue);
    expect(snapshot.sync.supportsXdripLocal, isTrue);
    expect(snapshot.sync.supportsContinuousBackgroundSync, isTrue);
    expect(snapshot.alert.supportsBackgroundEvaluation, isTrue);
    expect(snapshot.alert.supportsGuaranteedRealtime, isFalse);
  });

  test('iOS preview uses best-effort refresh without guaranteed realtime', () {
    const snapshot = PlatformRuntimeCapabilitySnapshot.iosPreview();

    expect(snapshot.platform, PlatformRuntime.ios);
    expect(snapshot.sync.supportsNightscoutApi, isTrue);
    expect(snapshot.sync.supportsXdripLocal, isFalse);
    expect(snapshot.sync.supportsForegroundSync, isTrue);
    expect(snapshot.sync.supportsResumeSync, isTrue);
    expect(snapshot.sync.supportsBackgroundRefresh, isTrue);
    expect(snapshot.sync.supportsContinuousBackgroundSync, isFalse);
    expect(snapshot.alert.supportsForegroundAlerts, isTrue);
    expect(snapshot.alert.supportsBackgroundEvaluation, isTrue);
    expect(snapshot.alert.supportsGuaranteedRealtime, isFalse);
  });
}
