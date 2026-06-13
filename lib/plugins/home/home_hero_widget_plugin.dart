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
import 'widgets/home_hero_glucose_card.dart';
import 'widgets/home_render_scope.dart';

class HomeHeroWidgetPlugin extends SmartFeaturePlugin {
  const HomeHeroWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.hero_glucose');

  @override
  String get title => 'Current Glucose';

  @override
  String get description => 'Latest glucose value and trend summary.';

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
          renderKey: 'home.hero_glucose',
          title: 'Current Glucose',
          order: 20,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => const HomeWidgetPluginEntry(
        widgetKey: 'home.hero_glucose',
        title: 'Current Glucose',
        description: 'Latest glucose value',
        order: 20,
      );

  @override
  List<PluginRoute> get routes => const [];

  @override
  void install(PluginInstallContext context) {
    context.compositionRegistry.register(
      PluginRenderable(
        pluginId: id,
        slot: HomeSlots.widget,
        renderKey: 'home.hero_glucose',
        title: 'Current Glucose',
        order: 20,
        builder: (renderContext) {
          final scope = HomeRenderScope.of(renderContext.buildContext);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HomeHeroGlucoseCard(
                glucose: scope.viewModel.glucose,
                inspectingPast: scope.inspectingPast,
              ),
              const SizedBox(height: 18),
            ],
          );
        },
      ),
    );
  }
}
