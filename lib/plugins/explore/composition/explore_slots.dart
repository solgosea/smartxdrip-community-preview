import 'package:smart_xdrip/plugin_platform/graph/plugin_slot.dart';
import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';

class ExploreSlots {
  static const hero = PluginSlotKey('explore.hero');
  static const feature = PluginSlotKey('explore.feature');
  static const card = PluginSlotKey('explore.card');
  static const wellness = PluginSlotKey('explore.wellness');
  static const tool = PluginSlotKey('explore.tool');
  static const detailAction = PluginSlotKey('explore.detailAction');

  static const all = [
    PluginSlot(key: hero, title: 'Hero', order: 10),
    PluginSlot(key: feature, title: 'Featured', order: 20),
    PluginSlot(key: card, title: 'Cards', order: 30),
    PluginSlot(key: wellness, title: 'Wellness', order: 40),
    PluginSlot(key: tool, title: 'Tools', order: 50),
    PluginSlot(key: detailAction, title: 'Detail Actions', order: 60),
  ];
}
