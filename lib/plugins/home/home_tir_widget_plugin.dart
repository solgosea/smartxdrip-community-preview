import '../../plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/widgets.dart';

import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/rendering/plugin_renderable.dart';
import 'composition/home_slots.dart';
import 'widgets/home_render_scope.dart';
import 'widgets/home_tir_section.dart';

class HomeTirWidgetPlugin extends SmartFeaturePlugin {
  const HomeTirWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.tir');

  @override
  String get title => 'Time In Range';

  @override
  String get description => 'Time-in-range summary for the current view.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: HomeSlots.widget,
          renderKey: 'home.tir',
          title: 'Time In Range',
          order: 50,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => const HomeWidgetPluginEntry(
        widgetKey: 'home.tir',
        title: 'Time In Range',
        description: 'TIR section',
        order: 50,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: HomeSlots.widget,
        renderKey: 'home.tir',
        title: 'Time In Range',
        order: 50,
        builder: (renderContext) {
          final scope = HomeRenderScope.of(renderContext.buildContext);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeTirSection(viewModel: scope.viewModel.tir),
              const SizedBox(height: 12),
            ],
          );
        },
      ),
    );
  }
}
