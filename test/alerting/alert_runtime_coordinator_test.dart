import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/runtime/alert_runtime_coordinator.dart';
import 'package:smart_xdrip/application/platform_runtime/platform_runtime_capability_snapshot.dart';

void main() {
  test('iOS alert runtime exposes best-effort background limitation', () {
    const coordinator = AlertRuntimeCoordinator(
      platformCapabilities: PlatformRuntimeCapabilitySnapshot.iosPreview(),
    );

    final status = coordinator.status;

    expect(status.foregroundAvailable, isTrue);
    expect(status.backgroundEvaluationAvailable, isTrue);
    expect(status.realtimeGuaranteed, isFalse);
    expect(status.message, contains('best-effort'));
  });
}
