import '../contracts/plugin_id.dart';
import 'plugin_node_kind.dart';
import 'plugin_slot.dart';

class PluginNode {
  final PluginId id;
  final PluginNodeKind kind;
  final List<PluginSlot> slots;

  const PluginNode({
    required this.id,
    required this.kind,
    this.slots = const [],
  });
}
