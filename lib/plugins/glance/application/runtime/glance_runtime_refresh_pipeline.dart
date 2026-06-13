import '../glance_persistent_notification_service.dart';
import '../glance_widget_config_service.dart';
import 'glance_runtime_refresh_result.dart';

class GlanceRuntimeRefreshPipeline {
  final GlanceWidgetConfigService widgetConfigService;
  final GlancePersistentNotificationService notificationService;
  final DateTime Function() now;

  const GlanceRuntimeRefreshPipeline({
    required this.widgetConfigService,
    required this.notificationService,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<GlanceRuntimeRefreshResult> run({
    required String reason,
    required bool force,
  }) async {
    final snapshot = await widgetConfigService.refreshAll();
    await notificationService.update(snapshot);
    return GlanceRuntimeRefreshResult(
      reason: reason,
      force: force,
      snapshot: snapshot,
      completedAt: now(),
    );
  }
}
