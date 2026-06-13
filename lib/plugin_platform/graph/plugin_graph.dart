import '../contracts/plugin_id.dart';
import 'plugin_node.dart';

class PluginGraph {
  final Map<PluginId, PluginNode> _nodes;

  PluginGraph(Iterable<PluginNode> nodes)
      : _nodes = {
          for (final node in nodes) node.id: node,
        };

  List<PluginNode> get nodes => List.unmodifiable(_nodes.values);

  PluginNode? nodeFor(PluginId id) => _nodes[id];
}
