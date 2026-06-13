import 'package:smart_xdrip/plugin_platform/graph/plugin_slot.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';

class SettingsSlots {
  static const section = PluginSlotKey('settings.section');

  static const all = [
    PluginSlot(key: section, title: 'Settings Sections', order: 10),
  ];
}
