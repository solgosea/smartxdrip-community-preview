import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugin_platform/rendering/plugin_slot_renderer.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../composition/profile_slots.dart';

class ProfileSectionSlotHost extends StatelessWidget {
  const ProfileSectionSlotHost({super.key});

  @override
  Widget build(BuildContext context) {
    return const PluginSlotRenderer(
      slot: ProfileSlots.section,
      labelBuilder: _sectionLabel,
    );
  }
}

Widget _sectionLabel(BuildContext context, String title) {
  return SectionLabel(title);
}
