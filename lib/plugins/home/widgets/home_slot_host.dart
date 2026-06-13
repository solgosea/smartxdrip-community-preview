import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_slot_renderer.dart';

import '../composition/home_slots.dart';

class HomeSlotHost extends StatelessWidget {
  const HomeSlotHost({super.key});

  @override
  Widget build(BuildContext context) {
    return const PluginSlotRenderer(
      slot: HomeSlots.widget,
    );
  }
}
