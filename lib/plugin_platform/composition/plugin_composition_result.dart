import 'plugin_placement_spec.dart';
import '../rendering/plugin_renderable.dart';

class PluginCompositionResult {
  final List<PluginRenderable> renderables;
  final List<PluginPlacementSpec> placements;

  const PluginCompositionResult({
    this.renderables = const [],
    this.placements = const [],
  });
}
