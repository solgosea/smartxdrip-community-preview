import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';

import '../data/schema/glance_schema_contributor.dart';
import 'glance_composition_registrar.dart';
import 'glance_runtime_registrar.dart';
import 'glance_service_registrar.dart';

class GlanceInstallModule {
  final GlanceServiceRegistrar serviceRegistrar;
  final GlanceCompositionRegistrar compositionRegistrar;
  final GlanceRuntimeRegistrar runtimeRegistrar;

  const GlanceInstallModule({
    this.serviceRegistrar = const GlanceServiceRegistrar(),
    this.compositionRegistrar = const GlanceCompositionRegistrar(),
    this.runtimeRegistrar = const GlanceRuntimeRegistrar(),
  });

  void install(PluginInstallContext context, PluginId pluginId) {
    context.registerSchema(const GlanceSchemaContributor());
    final bundle = serviceRegistrar.install(context);
    compositionRegistrar.register(context, pluginId);
    runtimeRegistrar.register(context, bundle);
  }
}
