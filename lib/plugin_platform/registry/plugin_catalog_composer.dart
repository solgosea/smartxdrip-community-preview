import '../composition/plugin_placement_spec.dart';
import '../contracts/smart_feature_plugin.dart';
import '../graph/plugin_graph.dart';

class PluginCatalogComposer {
  const PluginCatalogComposer();

  PluginGraph graphFor(List<SmartFeaturePlugin> plugins) {
    return PluginGraph(plugins.map((plugin) => plugin.node));
  }

  List<PluginPlacementSpec> placementsFor(List<SmartFeaturePlugin> plugins) {
    return [
      for (final plugin in plugins) ...plugin.placementSpecs,
    ];
  }
}
