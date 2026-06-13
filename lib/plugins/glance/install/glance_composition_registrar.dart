import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_renderable.dart';
import 'package:smart_xdrip/plugins/profile/composition/profile_slots.dart';

import '../composition/glance_profile_placement.dart';
import '../presentation/profile_section/glance_profile_section.dart';

class GlanceCompositionRegistrar {
  const GlanceCompositionRegistrar();

  void register(PluginInstallContext context, PluginId pluginId) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: pluginId,
        slot: ProfileSlots.section,
        renderKey: GlanceProfilePlacement.renderKey,
        title: GlanceProfilePlacement.title,
        order: GlanceProfilePlacement.order,
        builder: (renderContext) => GlanceProfileSection(
          renderContext: renderContext,
        ),
      ),
    );
  }
}
