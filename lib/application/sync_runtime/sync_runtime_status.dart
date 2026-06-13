import '../platform_runtime/sync_runtime_capability.dart';
import 'sync_runtime_mode.dart';

class SyncRuntimeStatus {
  final SyncRuntimeMode mode;
  final SyncRuntimeCapability capability;
  final bool continuousBackgroundActive;
  final String message;
  final DateTime? lastForegroundReconcileAt;
  final String? lastForegroundReconcileMessage;

  const SyncRuntimeStatus({
    required this.mode,
    required this.capability,
    required this.continuousBackgroundActive,
    required this.message,
    this.lastForegroundReconcileAt,
    this.lastForegroundReconcileMessage,
  });

  bool get supportsReliableBackgroundSync =>
      capability.supportsContinuousBackgroundSync && continuousBackgroundActive;
}
