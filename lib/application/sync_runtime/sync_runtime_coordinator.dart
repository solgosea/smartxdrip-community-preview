import '../../domain/entities/app_settings.dart';
import '../background_runtime/background_runtime_decision.dart';
import '../background_runtime/background_runtime_orchestrator.dart';
import '../foreground_reconcile/foreground_reconcile_decision.dart';
import '../foreground_reconcile/foreground_reconcile_orchestrator.dart';
import '../platform_runtime/platform_runtime_capability_snapshot.dart';
import 'sync_runtime_policy.dart';
import 'sync_runtime_status.dart';

class SyncRuntimeCoordinator {
  final PlatformRuntimeCapabilitySnapshot platformCapabilities;
  final BackgroundRuntimeOrchestrator backgroundRuntime;
  final ForegroundReconcileOrchestrator foregroundReconcile;
  final SyncRuntimePolicy policy;

  BackgroundRuntimeDecision? _lastBackgroundDecision;
  ForegroundReconcileDecision? _lastForegroundDecision;

  SyncRuntimeCoordinator({
    required this.platformCapabilities,
    required this.backgroundRuntime,
    required this.foregroundReconcile,
    this.policy = const SyncRuntimePolicy(),
  });

  BackgroundRuntimeDecision? get lastBackgroundDecision =>
      _lastBackgroundDecision;

  ForegroundReconcileDecision? get lastForegroundDecision =>
      _lastForegroundDecision;

  SyncRuntimeStatus get status => policy.evaluate(
        capability: platformCapabilities.sync,
        backgroundDecision: _lastBackgroundDecision,
        lastForegroundReconcileAt: foregroundReconcile.lastCompletedAt,
        lastForegroundReconcileMessage: _lastForegroundDecision?.reason,
      );

  Future<SyncRuntimeStatus> syncBackground(AppSettings settings) async {
    if (!platformCapabilities.sync.supportsContinuousBackgroundSync) {
      _lastBackgroundDecision = null;
      return status;
    }
    _lastBackgroundDecision = await backgroundRuntime.sync(settings);
    return status;
  }

  Future<ForegroundReconcileDecision> reconcileForeground() async {
    _lastForegroundDecision = await foregroundReconcile.run();
    return _lastForegroundDecision!;
  }
}
