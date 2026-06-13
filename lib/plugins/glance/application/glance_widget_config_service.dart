import '../../../domain/entities/app_settings.dart';
import '../data/platform/glance_widget_platform_bridge.dart';
import '../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../domain/glance_snapshot.dart';
import 'glance_snapshot_service.dart';

class GlanceWidgetConfigService {
  final SqliteGlanceWidgetConfigRepository repository;
  final GlanceSnapshotService snapshotService;
  final GlanceWidgetPlatformBridge widgetBridge;
  final AppSettings Function() settingsProvider;

  const GlanceWidgetConfigService({
    required this.repository,
    required this.snapshotService,
    required this.widgetBridge,
    required this.settingsProvider,
  });

  Future<GlanceWidgetConfig> defaultConfig({int widgetId = 0}) {
    return repository.getOrDefault(widgetId, settingsProvider().unit);
  }

  Future<void> save(GlanceWidgetConfig config) async {
    await repository.save(config);
    final snapshot = await snapshotService.current(
      range: config.graphRange,
      unit: settingsProvider().unit,
    );
    await widgetBridge.publishConfig(config, snapshot);
    await widgetBridge.updateWidget(config, snapshot);
  }

  Future<GlanceSnapshot> refreshAll() async {
    final configs = await repository.all();
    final config = configs.isEmpty
        ? GlanceWidgetConfig(
            widgetId: 0,
            primaryUnit: settingsProvider().unit,
          )
        : configs.first;
    final snapshot = await snapshotService.current(
      range: config.graphRange,
      unit: settingsProvider().unit,
    );
    await refreshAllWithSnapshot(snapshot, config: config);
    return snapshot;
  }

  Future<void> refreshAllWithSnapshot(
    GlanceSnapshot snapshot, {
    GlanceWidgetConfig? config,
  }) async {
    final configs = await repository.all();
    final effectiveConfig = config ??
        (configs.isEmpty
            ? GlanceWidgetConfig(
                widgetId: 0,
                primaryUnit: settingsProvider().unit,
              )
            : configs.first);
    await widgetBridge.publishConfig(effectiveConfig, snapshot);
    await widgetBridge.publishSnapshot(effectiveConfig, snapshot);
    await widgetBridge.updateAll(effectiveConfig, snapshot);
  }
}
