import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import 'target_range_profile_view_model.dart';

class TargetRangeProfileViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;

  const TargetRangeProfileViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  TargetRangeProfileViewModel map(AppSettings settings) {
    final target = glucoseFormatter.range(
      settings.lowThreshold,
      settings.highThreshold,
      settings.unit,
    );
    final low = glucoseFormatter.value(settings.lowThreshold, settings.unit);
    final high = glucoseFormatter.value(settings.highThreshold, settings.unit);
    final veryHigh = glucoseFormatter.value(
      settings.veryHighThreshold,
      settings.unit,
    );
    return TargetRangeProfileViewModel(
      ranges: [
        TargetRangeProfileRowViewModel(
          icon: Icons.stacked_line_chart_rounded,
          label: 'Target range',
          subtitle: 'Primary glucose band',
          valueLabel: target.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.trending_down_rounded,
          label: 'Low threshold',
          subtitle: 'Below this enters low range',
          valueLabel: low.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.trending_up_rounded,
          label: 'High threshold',
          subtitle: 'Above this enters high range',
          valueLabel: high.fullLabel,
        ),
        TargetRangeProfileRowViewModel(
          icon: Icons.warning_amber_rounded,
          label: 'Very high threshold',
          subtitle: 'Marked as urgent high zone',
          valueLabel: veryHigh.fullLabel,
        ),
      ],
    );
  }
}
