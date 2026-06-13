import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_slot_renderer.dart';

import '../composition/settings_slots.dart';

class SettingsSlotHost extends StatelessWidget {
  final Widget Function(BuildContext context, String title)? labelBuilder;

  const SettingsSlotHost({
    super.key,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return PluginSlotRenderer(
      slot: SettingsSlots.section,
      labelBuilder: labelBuilder,
    );
  }
}
