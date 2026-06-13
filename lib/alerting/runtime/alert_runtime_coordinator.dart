import '../../application/platform_runtime/platform_runtime_capability_snapshot.dart';
import 'alert_runtime_status.dart';

class AlertRuntimeCoordinator {
  final PlatformRuntimeCapabilitySnapshot platformCapabilities;

  const AlertRuntimeCoordinator({
    required this.platformCapabilities,
  });

  AlertRuntimeStatus get status {
    final capability = platformCapabilities.alert;
    return AlertRuntimeStatus(
      capability: capability,
      foregroundAvailable: capability.supportsForegroundAlerts,
      backgroundEvaluationAvailable: capability.supportsBackgroundEvaluation,
      realtimeGuaranteed: capability.supportsGuaranteedRealtime,
      message: capability.limitationText,
    );
  }
}
