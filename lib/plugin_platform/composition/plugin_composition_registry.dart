import '../graph/plugin_slot_key.dart';
import '../rendering/plugin_renderable.dart';

class PluginCompositionRegistry {
  final Map<PluginSlotKey, List<PluginRenderable>> _renderablesBySlot = {};

  void register(PluginRenderable renderable) {
    final renderables =
        _renderablesBySlot.putIfAbsent(renderable.slot, () => []);
    final duplicateIndex = renderables.indexWhere(
      (current) =>
          current.pluginId == renderable.pluginId &&
          current.renderKey == renderable.renderKey,
    );
    if (duplicateIndex >= 0) {
      renderables[duplicateIndex] = renderable;
      return;
    }
    renderables.add(renderable);
  }

  List<PluginRenderable> renderablesFor(PluginSlotKey slot) {
    final renderables = List<PluginRenderable>.from(
      _renderablesBySlot[slot] ?? const [],
    );
    renderables.sort((a, b) => a.order.compareTo(b.order));
    return renderables;
  }
}
