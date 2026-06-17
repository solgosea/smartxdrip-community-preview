import '../composition/explore_slots.dart';
import '../../../plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/material.dart';

import '../../../application/analysis/analysis_facade.dart';
import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../../plugin_platform/install/plugin_install_context.dart';
import '../../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/report_snapshot_preheater.dart';
import 'pages/report_page.dart';
import 'runtime/report_plugin_runtime.dart';
import 'runtime/report_runtime_cache.dart';

class ReportPlugin extends SmartFeaturePlugin {
  const ReportPlugin();

  @override
  PluginId get id => const PluginId('explore.report');

  @override
  String get title => 'Glucose Report';

  @override
  String get description => 'AGP-style local report with PDF export.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.exploreCard};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.agpSlots,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ExploreSlots.card,
          renderKey: '/explore/report',
          title: 'Glucose Report',
          order: 210,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  ExplorePluginEntry get exploreEntry => const ExplorePluginEntry(
        section: 'GLUCOSE PROFILE',
        title: 'Glucose Report',
        subtitle: 'AGP-style PDF export',
        route: '/explore/report',
        icon: Icons.description_rounded,
        order: 210,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(
          path: '/explore/report',
          builder: (_) => const ReportPage(),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    final cache = ReportRuntimeCache();
    final runtime = ReportPluginRuntime(
      cache: cache,
      preheater: const ReportSnapshotPreheater(
        facadeProvider: AnalysisFacade.current,
      ),
    );
    context.services.register<ReportRuntimeCache>(cache);
    context.services.register<ReportPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
