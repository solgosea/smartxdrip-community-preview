import 'package:smart_xdrip/plugin_platform/graph/plugin_slot.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';

class HomeSlots {
  static const widget = PluginSlotKey('home.widget');

  static const all = [
    PluginSlot(key: widget, title: 'Home Widgets', order: 10),
  ];
}
