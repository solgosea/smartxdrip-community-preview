import '../background_runtime/background_runtime_decision.dart';
import '../platform_runtime/sync_runtime_capability.dart';
import 'sync_runtime_mode.dart';
import 'sync_runtime_status.dart';

class SyncRuntimePolicy {
  const SyncRuntimePolicy();

  SyncRuntimeStatus evaluate({
    required SyncRuntimeCapability capability,
    BackgroundRuntimeDecision? backgroundDecision,
    DateTime? lastForegroundReconcileAt,
    String? lastForegroundReconcileMessage,
  }) {
    if (capability.supportsContinuousBackgroundSync) {
      final active = backgroundDecision?.shouldRun ?? false;
      return SyncRuntimeStatus(
        mode: SyncRuntimeMode.continuousBackground,
        capability: capability,
        continuousBackgroundActive: active,
        message: active
            ? 'Continuous background sync is active.'
            : 'Continuous background sync is ready.',
        lastForegroundReconcileAt: lastForegroundReconcileAt,
        lastForegroundReconcileMessage: lastForegroundReconcileMessage,
      );
    }

    if (capability.supportsBackgroundRefresh) {
      return SyncRuntimeStatus(
        mode: SyncRuntimeMode.bestEffortBackground,
        capability: capability,
        continuousBackgroundActive: false,
        message: capability.limitationText,
        lastForegroundReconcileAt: lastForegroundReconcileAt,
        lastForegroundReconcileMessage: lastForegroundReconcileMessage,
      );
    }

    if (capability.supportsResumeSync) {
      return SyncRuntimeStatus(
        mode: SyncRuntimeMode.foregroundAndResume,
        capability: capability,
        continuousBackgroundActive: false,
        message: capability.limitationText,
        lastForegroundReconcileAt: lastForegroundReconcileAt,
        lastForegroundReconcileMessage: lastForegroundReconcileMessage,
      );
    }

    return SyncRuntimeStatus(
      mode: SyncRuntimeMode.foregroundOnly,
      capability: capability,
      continuousBackgroundActive: false,
      message: capability.limitationText,
      lastForegroundReconcileAt: lastForegroundReconcileAt,
      lastForegroundReconcileMessage: lastForegroundReconcileMessage,
    );
  }
}
