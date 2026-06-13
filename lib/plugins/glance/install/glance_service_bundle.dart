import '../application/glance_navigation_action_resolver.dart';
import '../application/glance_persistent_notification_service.dart';
import '../application/glance_runtime_coordinator.dart';
import '../application/glance_snapshot_service.dart';
import '../application/glance_widget_config_service.dart';
import '../data/platform/glance_widget_platform_bridge.dart';
import '../data/sqlite/sqlite_glance_settings_repository.dart';
import '../data/sqlite/sqlite_glance_widget_config_repository.dart';

class GlanceServiceBundle {
  final GlanceSnapshotService snapshotService;
  final SqliteGlanceWidgetConfigRepository widgetConfigRepository;
  final SqliteGlanceSettingsRepository settingsRepository;
  final GlanceWidgetPlatformBridge widgetBridge;
  final GlancePersistentNotificationService notificationService;
  final GlanceWidgetConfigService widgetConfigService;
  final GlanceNavigationActionResolver navigationActionResolver;
  final GlanceRuntimeCoordinator runtimeCoordinator;

  const GlanceServiceBundle({
    required this.snapshotService,
    required this.widgetConfigRepository,
    required this.settingsRepository,
    required this.widgetBridge,
    required this.notificationService,
    required this.widgetConfigService,
    required this.navigationActionResolver,
    required this.runtimeCoordinator,
  });
}
