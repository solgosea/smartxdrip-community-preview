import '../../../plugin_platform/composition/plugin_placement_spec.dart';
import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../../plugin_platform/install/plugin_install_context.dart';
import '../../../plugin_platform/rendering/plugin_renderable.dart';
import '../composition/settings_slots.dart';
import '../widgets/settings_about_block.dart';
import '../widgets/settings_render_scope.dart';

class SettingsAboutPlugin extends SmartFeaturePlugin {
  const SettingsAboutPlugin();

  @override
  PluginId get id => const PluginId('settings.about');

  @override
  String get title => 'About';

  @override
  String get description => 'Application metadata and support links.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.settingsSection,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {};
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: SettingsSlots.section,
          renderKey: 'About',
          title: 'About',
          order: 60,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
        section: 'About',
        title: 'About',
        subtitle: 'Application information',
        order: 60,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: SettingsSlots.section,
        renderKey: 'settings.about.section',
        title: 'About',
        order: 60,
        builder: (renderContext) {
          final scope = SettingsRenderScope.of(renderContext.buildContext);
          return SettingsAboutBlock(viewModel: scope.viewModel.about);
        },
      ),
    );
  }
}
