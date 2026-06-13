import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/background_runtime/background_runtime_decision.dart';
import 'package:smart_xdrip/application/background_runtime/background_runtime_reason.dart';
import 'package:smart_xdrip/application/platform_runtime/platform_runtime_capability_snapshot.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_mode.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_policy.dart';

void main() {
  const policy = SyncRuntimePolicy();

  test('Android uses continuous background mode when available', () {
    final status = policy.evaluate(
      capability: const PlatformRuntimeCapabilitySnapshot.android().sync,
      backgroundDecision: BackgroundRuntimeDecision.fromReasons({
        BackgroundRuntimeReason.selfDatasourceEnabled,
      }),
    );

    expect(status.mode, SyncRuntimeMode.continuousBackground);
    expect(status.continuousBackgroundActive, isTrue);
    expect(status.supportsReliableBackgroundSync, isTrue);
  });

  test('iOS preview uses best-effort background mode', () {
    final status = policy.evaluate(
      capability: const PlatformRuntimeCapabilitySnapshot.iosPreview().sync,
      lastForegroundReconcileAt: DateTime(2026, 6, 10, 12),
      lastForegroundReconcileMessage:
          'iOS foreground resume requires full reconcile.',
    );

    expect(status.mode, SyncRuntimeMode.bestEffortBackground);
    expect(status.continuousBackgroundActive, isFalse);
    expect(status.supportsReliableBackgroundSync, isFalse);
    expect(status.message, contains('best-effort'));
    expect(status.lastForegroundReconcileAt, isNotNull);
  });
}
