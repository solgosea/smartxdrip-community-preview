import 'package:smart_xdrip/application/glucose_unit/glucose_threshold_format_service.dart';
import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../application/text/statistics_metrics_text_builder.dart';
import '../domain/sections/statistics_metrics_section.dart';
import '../domain/statistics_delta_tone.dart' as domain;
import '../models/statistics_view_model.dart';

class StatisticsMetricsViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final GlucoseThresholdFormatService thresholdFormatter;
  final StatisticsMetricsTextBuilder textBuilder;

  const StatisticsMetricsViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.thresholdFormatter = const GlucoseThresholdFormatService(),
    this.textBuilder = const StatisticsMetricsTextBuilder(),
  });

  String header(String windowLabel) => textBuilder.header(windowLabel);

  List<StatisticsMetricCardViewModel> map({
    required StatisticsMetricsSection section,
    required AppSettings settings,
    required String previousWindowLabel,
  }) {
    final unit = settings.unit;
    final mean = glucoseFormatter.value(section.meanMmol, unit);
    final sd = glucoseFormatter.value(section.sdMmol, unit);
    final meanDelta = glucoseFormatter.value(section.meanDeltaMmol, unit);
    final sdDelta = glucoseFormatter.value(section.sdDeltaMmol, unit);

    return [
      StatisticsMetricCardViewModel(
        label: textBuilder.tirLabel(),
        value: section.tir.toStringAsFixed(0),
        valueColor: section.tir >= 70
            ? AppColors.green
            : section.tir >= 50
                ? AppColors.amber
                : AppColors.rose,
        suffix: '%',
        unit: thresholdFormatter.targetRange(settings),
        deltaText: _deltaText(
          section.tirDelta,
          suffix: '% vs prev $previousWindowLabel',
        ),
        deltaTone: _tone(section.tirTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.averageLabel(),
        value: mean.valueLabel,
        valueColor: AppColors.text,
        unit: '${mean.unitLabel} - GMI ${section.gmi.toStringAsFixed(1)}%',
        deltaText:
            _deltaText(meanDelta.value, suffix: ' ${meanDelta.unitLabel}'),
        deltaTone: _tone(section.meanTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.cvLabel(),
        value: section.cv.toStringAsFixed(0),
        valueColor: section.cvStable ? AppColors.green : AppColors.amber,
        suffix: '%',
        unit: textBuilder.cvStatus(stable: section.cvStable),
        deltaText: _deltaText(section.cvDelta, suffix: '%'),
        deltaTone: _tone(section.cvTone),
      ),
      StatisticsMetricCardViewModel(
        label: textBuilder.sdLabel(),
        value: sd.valueLabel,
        valueColor: AppColors.text,
        unit: sd.unitLabel,
        deltaText: _deltaText(sdDelta.value, suffix: ' ${sdDelta.unitLabel}'),
        deltaTone: _tone(section.sdTone),
      ),
    ];
  }

  String _deltaText(double delta, {required String suffix}) {
    if (delta.abs() < 0.05) return 'same';
    final sign = delta > 0 ? '+' : '';
    return '$sign${delta.toStringAsFixed(1)}$suffix';
  }

  StatisticsDeltaTone _tone(domain.StatisticsDeltaToneSignal tone) {
    return switch (tone) {
      domain.StatisticsDeltaToneSignal.up => StatisticsDeltaTone.up,
      domain.StatisticsDeltaToneSignal.down => StatisticsDeltaTone.down,
      domain.StatisticsDeltaToneSignal.flat => StatisticsDeltaTone.flat,
    };
  }
}
