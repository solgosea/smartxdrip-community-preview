import 'plugin_slot_key.dart';

class PluginSlot {
  final PluginSlotKey key;
  final String title;
  final int order;

  const PluginSlot({
    required this.key,
    required this.title,
    required this.order,
  });
}
