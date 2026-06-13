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
import '../widgets/settings_render_scope.dart';
import '../widgets/settings_storage_actions_group.dart';

class SettingsSyncPlugin extends SmartFeaturePlugin {
  const SettingsSyncPlugin();

  @override
  PluginId get id => const PluginId('settings.sync');

  @override
  String get title => 'Sync Settings';

  @override
  String get description => 'Initial sync window and source sync preferences.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.settingsSection,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.appSettings,
        PluginDataRequirement.syncStatus,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: SettingsSlots.section,
          renderKey: 'Sync Settings',
          title: 'Sync Settings',
          order: 20,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
        section: 'Sync Settings',
        title: 'Sync Settings',
        subtitle: 'Source sync behavior',
        order: 20,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: SettingsSlots.section,
        renderKey: 'settings.sync.section',
        title: 'Sync Settings',
        order: 20,
        builder: (renderContext) {
          final scope = SettingsRenderScope.of(renderContext.buildContext);
          return SettingsStorageActionsGroup(
            viewModel: scope.viewModel.sync,
            onPickInitialSyncWindow: scope.onPickInitialSyncWindow,
            onExportCsv: scope.onExportCsv,
          );
        },
      ),
    );
  }
}
