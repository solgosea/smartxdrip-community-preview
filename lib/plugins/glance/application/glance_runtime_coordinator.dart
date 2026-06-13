import 'runtime/glance_runtime_refresh_pipeline.dart';
import 'runtime/glance_runtime_refresh_result.dart';

class GlanceRuntimeCoordinator {
  final GlanceRuntimeRefreshPipeline refreshPipeline;

  const GlanceRuntimeCoordinator({
    required this.refreshPipeline,
  });

  Future<GlanceRuntimeRefreshResult> refresh({
    String reason = 'manual',
    bool force = false,
  }) async {
    return refreshPipeline.run(reason: reason, force: force);
  }
}
