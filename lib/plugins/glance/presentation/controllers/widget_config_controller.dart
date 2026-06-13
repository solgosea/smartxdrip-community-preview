import 'package:flutter/foundation.dart';

import '../../../../domain/entities/app_settings.dart';
import '../../application/glance_snapshot_service.dart';
import '../../application/glance_widget_config_service.dart';
import '../../data/sqlite/sqlite_glance_widget_config_repository.dart';
import '../../domain/glance_snapshot.dart';

class WidgetConfigController extends ChangeNotifier {
  final GlanceWidgetConfigService configService;
  final GlanceSnapshotService snapshotService;
  final AppSettings Function() settingsProvider;

  GlanceWidgetConfig? config;
  GlanceSnapshot? snapshot;
  bool loading = true;

  WidgetConfigController({
    required this.configService,
    required this.snapshotService,
    required this.settingsProvider,
  });

  Future<void> load({int widgetId = 0}) async {
    loading = true;
    notifyListeners();
    config = await configService.defaultConfig(widgetId: widgetId);
    snapshot = await snapshotService.current(
      range: config!.graphRange,
      unit: settingsProvider().unit,
    );
    loading = false;
    notifyListeners();
  }

  Future<void> update(GlanceWidgetConfig next) async {
    config = next;
    snapshot = await snapshotService.current(
      range: next.graphRange,
      unit: settingsProvider().unit,
    );
    notifyListeners();
  }

  Future<void> save() async {
    final current = config;
    if (current == null) return;
    await configService.save(current);
    snapshot = await snapshotService.current(
      range: current.graphRange,
      unit: settingsProvider().unit,
    );
    notifyListeners();
  }
}
