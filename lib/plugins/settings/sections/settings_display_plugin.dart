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
import '../widgets/settings_display_group.dart';
import '../widgets/settings_render_scope.dart';

class SettingsDisplayPlugin extends SmartFeaturePlugin {
  const SettingsDisplayPlugin();

  @override
  PluginId get id => const PluginId('settings.display');

  @override
  String get title => 'Display';

  @override
  String get description => 'Display preferences for glucose units.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.settingsSection,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: SettingsSlots.section,
          renderKey: 'Display',
          title: 'Display',
          order: 10,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
        section: 'Display',
        title: 'Display',
        subtitle: 'Units and presentation preferences',
        order: 10,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: SettingsSlots.section,
        renderKey: 'settings.display.section',
        title: 'Display',
        order: 10,
        builder: (renderContext) {
          final scope = SettingsRenderScope.of(renderContext.buildContext);
          return SettingsDisplayGroup(
            viewModel: scope.viewModel.display,
            onPickUnit: scope.onPickUnit,
          );
        },
      ),
    );
  }
}
