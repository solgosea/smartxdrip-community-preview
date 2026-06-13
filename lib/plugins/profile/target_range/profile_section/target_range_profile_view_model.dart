import 'package:flutter/material.dart';

class TargetRangeProfileViewModel {
  final List<TargetRangeProfileRowViewModel> ranges;

  const TargetRangeProfileViewModel({
    required this.ranges,
  });
}

class TargetRangeProfileRowViewModel {
  final IconData icon;
  final String label;
  final String subtitle;
  final String valueLabel;

  const TargetRangeProfileRowViewModel({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.valueLabel,
  });
}
