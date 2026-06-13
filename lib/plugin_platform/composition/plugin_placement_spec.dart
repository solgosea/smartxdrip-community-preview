import '../contracts/plugin_data_requirement.dart';
import '../contracts/plugin_id.dart';
import '../graph/plugin_slot_key.dart';

class PluginPlacementSpec {
  final PluginId pluginId;
  final PluginSlotKey slot;
  final String renderKey;
  final String title;
  final int order;
  final bool enabled;
  final Set<PluginDataRequirement> dataRequirements;

  const PluginPlacementSpec({
    required this.pluginId,
    required this.slot,
    required this.renderKey,
    required this.title,
    required this.order,
    this.enabled = true,
    this.dataRequirements = const {},
  });
}
