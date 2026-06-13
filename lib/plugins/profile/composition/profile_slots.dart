import 'package:smart_xdrip/plugin_platform/graph/plugin_slot.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';

class ProfileSlots {
  static const header = PluginSlotKey('profile.header');
  static const summary = PluginSlotKey('profile.summary');
  static const section = PluginSlotKey('profile.section');
  static const action = PluginSlotKey('profile.action');
  static const danger = PluginSlotKey('profile.danger');

  static const all = [
    PluginSlot(key: header, title: 'Header', order: 10),
    PluginSlot(key: summary, title: 'Summary', order: 20),
    PluginSlot(key: section, title: 'Sections', order: 30),
    PluginSlot(key: action, title: 'Actions', order: 40),
    PluginSlot(key: danger, title: 'Danger', order: 50),
  ];
}
