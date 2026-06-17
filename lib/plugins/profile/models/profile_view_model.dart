import 'package:flutter/material.dart';

class ProfileViewModel {
  final ProfileHeaderViewModel header;
  final List<ProfileStatViewModel> stats;
  final ProfileBaselineCardViewModel baseline;
  final String appSettingsSummary;

  const ProfileViewModel({
    required this.header,
    required this.stats,
    required this.baseline,
    required this.appSettingsSummary,
  });
}

class ProfileHeaderViewModel {
  final String title;
  final String primaryBadge;
  final String glucotypeBadge;

  const ProfileHeaderViewModel({
    required this.title,
    required this.primaryBadge,
    required this.glucotypeBadge,
  });
}

class ProfileStatViewModel {
  final String value;
  final String? unit;
  final String label;
  final Color valueColor;

  const ProfileStatViewModel({
    required this.value,
    this.unit,
    required this.label,
    required this.valueColor,
  });
}

class ProfileBaselineCardViewModel {
  final bool hasData;
  final String title;
  final String subtitle;
  final List<ProfileBaselineMiniMetricViewModel> metrics;

  const ProfileBaselineCardViewModel({
    required this.hasData,
    required this.title,
    required this.subtitle,
    required this.metrics,
  });
}

class ProfileBaselineMiniMetricViewModel {
  final String value;
  final String? unit;
  final String label;
  final Color valueColor;

  const ProfileBaselineMiniMetricViewModel({
    required this.value,
    this.unit,
    required this.label,
    required this.valueColor,
  });
}
