import 'package:smart_xdrip/application/background_sync/background_sync_post_task_registry.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';

import '../application/background/glance_background_widget_post_task.dart';
import '../runtime/glance_plugin_runtime.dart';
import 'glance_service_bundle.dart';

class GlanceRuntimeRegistrar {
  const GlanceRuntimeRegistrar();

  void register(PluginInstallContext context, GlanceServiceBundle bundle) {
    context.services
        .maybe<BackgroundSyncPostTaskRegistry>()
        ?.register(GlanceBackgroundWidgetPostTask(
          coordinator: bundle.runtimeCoordinator,
        ));

    context.registerRuntime(
      GlancePluginRuntime(
        coordinator: bundle.runtimeCoordinator,
        notificationService: bundle.notificationService,
      ),
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
