import 'package:smart_xdrip/application/background_sync/background_sync_post_task.dart';

import '../glance_runtime_coordinator.dart';

class GlanceBackgroundWidgetPostTask implements BackgroundSyncPostTask {
  final GlanceRuntimeCoordinator coordinator;

  const GlanceBackgroundWidgetPostTask({
    required this.coordinator,
  });

  @override
  Future<void> run(BackgroundSyncPostTaskContext context) {
    return coordinator.refresh(
      reason: context.syncSucceeded ? 'backgroundSync' : 'backgroundSyncFailed',
      force: true,
    );
  }
}
