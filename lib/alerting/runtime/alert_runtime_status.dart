import '../../application/platform_runtime/alert_runtime_capability.dart';

class AlertRuntimeStatus {
  final AlertRuntimeCapability capability;
  final bool foregroundAvailable;
  final bool backgroundEvaluationAvailable;
  final bool realtimeGuaranteed;
  final String message;

  const AlertRuntimeStatus({
    required this.capability,
    required this.foregroundAvailable,
    required this.backgroundEvaluationAvailable,
    required this.realtimeGuaranteed,
    required this.message,
  });
}
