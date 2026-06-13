import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/section_label.dart';

import '../models/profile_view_model.dart';
import 'profile_app_settings_card.dart';
import 'profile_header_card.dart';
import 'profile_slot_host.dart';
import 'profile_stats_strip.dart';

class ProfileBody extends StatelessWidget {
  final ProfileViewModel viewModel;
  final VoidCallback onSettingsTap;

  const ProfileBody({
    super.key,
    required this.viewModel,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProfileHeaderCard(viewModel: viewModel.header),
              ProfileStatsStrip(stats: viewModel.stats),
              const ProfileSectionSlotHost(),
              ..._sectionWidgets(context, 'App Settings'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _sectionWidgets(BuildContext context, String section) {
    return switch (section) {
      'App Settings' => [
          const SectionLabel('App Settings'),
          ProfileAppSettingsCard(
            summary: viewModel.appSettingsSummary,
            onTap: onSettingsTap,
          ),
        ],
      _ => const <Widget>[],
    };
  }
}
