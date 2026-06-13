import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugins/profile/composition/profile_slots.dart';

import 'composition/glance_profile_placement.dart';
import 'install/glance_install_module.dart';
import 'presentation/pages/glance_hub_page.dart';
import 'presentation/pages/persistent_notification_page.dart';
import 'presentation/pages/widget_config_page.dart';
import 'runtime/glance_plugin_runtime.dart';

class GlancePlugin extends SmartFeaturePlugin {
  const GlancePlugin();

  @override
  PluginId get id => GlancePluginRuntime.runtimeId;

  @override
  String get title => 'Widgets & Notification';

  @override
  String get description =>
      'Home screen widgets and persistent glucose status notification.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.beta;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.profileSection};

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ProfileSlots.section,
          renderKey: GlanceProfilePlacement.title,
          title: GlanceProfilePlacement.title,
          order: GlanceProfilePlacement.order,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.appSettings,
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.sourceConnection,
      };

  @override
  List<PluginRoute> get routes => [
        PluginRoute(path: '/glance', builder: (_) => const GlanceHubPage()),
        PluginRoute(
          path: '/glance/widgets/config',
          builder: (_) => const WidgetConfigPage(),
        ),
        PluginRoute(
          path: '/glance/notification',
          builder: (_) => const PersistentNotificationPage(),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    const GlanceInstallModule().install(context, id);
  }
}
