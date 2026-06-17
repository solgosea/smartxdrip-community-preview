import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/text/statistics_tir_text_builder.dart';
import '../domain/sections/statistics_tir_breakdown_section.dart';
import '../models/statistics_view_model.dart';

class StatisticsTirViewModelMapper {
  static const _veryHighColor = Color(0xFFA03030);
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final StatisticsTirTextBuilder textBuilder;

  const StatisticsTirViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.textBuilder = const StatisticsTirTextBuilder(),
  });

  StatisticsTirBreakdownViewModel map({
    required StatisticsTirBreakdownSection section,
    required AppSettings settings,
  }) {
    final veryLowLabel =
        '<${glucoseFormatter.value(3.0, settings.unit).valueLabel}';
    final veryHighLabel = thresholdFormatter.veryHighLabel(settings);
    final segments = [
      StatisticsTirSegmentViewModel(
        color: AppColors.blue,
        fraction: section.lowPct,
      ),
      StatisticsTirSegmentViewModel(
        color: AppColors.green,
        fraction: section.inRangePct,
      ),
      StatisticsTirSegmentViewModel(
        color: AppColors.rose,
        fraction: section.highPct,
      ),
      StatisticsTirSegmentViewModel(
        color: _veryHighColor,
        fraction: section.veryHighPct,
      ),
    ].where((segment) => segment.fraction > 0).toList(growable: false);

    return StatisticsTirBreakdownViewModel(
      segments: segments,
      legends: [
        StatisticsLegendItemViewModel(
          color: AppColors.blue,
          text: textBuilder.lowLegend(section.lowPct.toStringAsFixed(0)),
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.green,
          text: textBuilder.inRangeLegend(
            section.inRangePct.toStringAsFixed(0),
          ),
        ),
        StatisticsLegendItemViewModel(
          color: AppColors.rose,
          text: textBuilder.highLegend(section.highPct.toStringAsFixed(0)),
        ),
        StatisticsLegendItemViewModel(
          color: _veryHighColor,
          text: textBuilder.veryHighLegend(
            section.veryHighPct.toStringAsFixed(0),
          ),
        ),
      ],
      extremes: [
        StatisticsExtremeCellViewModel(
          label: textBuilder.veryLowExtreme(veryLowLabel),
          value: '${section.veryLowPct.toStringAsFixed(1)}%',
          subtitle: '~${section.veryLowMinutesPerDay} min/day',
        ),
        StatisticsExtremeCellViewModel(
          label: textBuilder.veryHighExtreme(veryHighLabel),
          value: '${section.veryHighPct.toStringAsFixed(0)}%',
          subtitle: '~${section.veryHighMinutesPerDay} min/day',
        ),
      ],
    );
  }
}
