import '../../domain/glance_snapshot.dart';
import '../sqlite/sqlite_glance_widget_config_repository.dart';

abstract interface class GlanceWidgetPlatformBridge {
  bool get isSupported;

  Future<void> publishSnapshot(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  );

  Future<void> publishConfig(
    GlanceWidgetConfig config,
    GlanceSnapshot snapshot,
  );

  Future<void> updateWidget(GlanceWidgetConfig config, GlanceSnapshot snapshot);

  Future<void> updateAll(GlanceWidgetConfig config, GlanceSnapshot snapshot);
}
