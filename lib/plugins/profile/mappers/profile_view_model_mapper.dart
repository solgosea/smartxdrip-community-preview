import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/analysis_results.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../analyzers/profile_summary_analyzer.dart';
import '../models/profile_view_model.dart';

class ProfileViewModelMapper {
  static const _months = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final ProfileSummaryAnalyzer analyzer;
  final GlucoseUnitFormatService glucoseFormatter;

  const ProfileViewModelMapper({
    this.analyzer = const ProfileSummaryAnalyzer(),
    this.glucoseFormatter = const GlucoseUnitFormatService(),
  });

  ProfileViewModel map({
    required AnalysisFacade facade,
    required AppSettings settings,
  }) {
    final result = analyzer.analyze(facade: facade);
    final average14d = glucoseFormatter.value(result.average14d, settings.unit);
    return ProfileViewModel(
      header: ProfileHeaderViewModel(
        title: 'My Profile',
        primaryBadge: result.baseline == null
            ? 'Building baseline'
            : '${result.baseline!.daysUsed} days recorded',
        glucotypeBadge: 'Glucotype: ${result.glucotype.label}',
      ),
      stats: [
        ProfileStatViewModel(
          value: result.tir14d.toStringAsFixed(0),
          unit: '%',
          label: 'TIR 14d',
          valueColor: _tirColor(result.tir14d),
        ),
        ProfileStatViewModel(
          value: average14d.valueLabel,
          unit: average14d.unitLabel,
          label: 'Avg 14d',
          valueColor: AppColors.text,
        ),
        ProfileStatViewModel(
          value: result.cv14d.toStringAsFixed(0),
          unit: '%',
          label: 'CV 14d',
          valueColor: _cvColor(result.cv14d),
        ),
      ],
      baseline: _baseline(result.baseline, settings.unit),
      appSettingsSummary: 'Settings',
    );
  }

  ProfileBaselineCardViewModel _baseline(
    PersonalBaseline? baseline,
    GlucoseUnit unit,
  ) {
    final hasData = baseline != null && baseline.daysUsed > 0;
    final peakRange = hasData
        ? glucoseFormatter.range(baseline.peakLow, baseline.peakHigh, unit)
        : null;
    return ProfileBaselineCardViewModel(
      hasData: hasData,
      title: 'Personal Glucose Baseline',
      subtitle: hasData
          ? 'Built from ${baseline.daysUsed} days - Updated ${_monthDay(baseline.updatedAt)}'
          : 'Not enough data yet',
      metrics: [
        ProfileBaselineMiniMetricViewModel(
          value: hasData
              ? '${baseline.tirLow.toStringAsFixed(0)}-${baseline.tirHigh.toStringAsFixed(0)}%'
              : '-',
          label: 'TIR baseline',
          valueColor: AppColors.green,
        ),
        ProfileBaselineMiniMetricViewModel(
          value:
              hasData ? '${peakRange!.lowLabel}-${peakRange.highLabel}' : '-',
          unit: hasData ? peakRange!.unitLabel : null,
          label: 'Typical peak',
          valueColor: AppColors.text,
        ),
        ProfileBaselineMiniMetricViewModel(
          value: hasData
              ? '${baseline.cvLow.toStringAsFixed(0)}-${baseline.cvHigh.toStringAsFixed(0)}%'
              : '-',
          label: 'CV range',
          valueColor: AppColors.text,
        ),
      ],
    );
  }

  Color _tirColor(double value) {
    return value >= 70 ? AppColors.text : AppColors.amber;
  }

  Color _cvColor(double value) {
    if (value <= 30) return AppColors.green;
    if (value <= 36) return AppColors.text;
    return AppColors.amber;
  }

  String _monthDay(DateTime date) => '${_months[date.month]} ${date.day}';
}
