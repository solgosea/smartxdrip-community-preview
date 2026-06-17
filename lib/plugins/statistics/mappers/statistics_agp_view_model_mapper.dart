import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';

import '../application/text/statistics_agp_text_builder.dart';
import '../domain/sections/statistics_agp_section.dart';
import '../models/statistics_view_model.dart';

class StatisticsAgpViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final StatisticsAgpTextBuilder textBuilder;

  const StatisticsAgpViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.textBuilder = const StatisticsAgpTextBuilder(),
  });

  StatisticsAgpViewModel map({
    required StatisticsAgpSection section,
    required AppSettings settings,
  }) {
    return StatisticsAgpViewModel(
      title:
          'AGP - Ambulatory Glucose Profile - ${section.window.label} pattern',
      guidanceText: section.showGuidance
          ? textBuilder.renderNotEnoughWindowGuidance()
          : '',
      slots: section.slots,
      unit: settings.unit,
      lowThreshold: settings.lowThreshold,
      highThreshold: settings.highThreshold,
      annotations: section.showDawnAnnotation
          ? const [
              AgpAnnotation(
                minuteOfDay: 300,
                labels: ['Dawn', 'phenomenon'],
                color: AppColors.amber,
                opacity: 0.5,
              ),
            ]
          : const [],
      note: _agpNote(section, settings),
    );
  }

  String _agpNote(StatisticsAgpSection section, AppSettings settings) {
    if (section.readings.isEmpty || section.slots.isEmpty) {
      return textBuilder.renderEmpty();
    }

    final unit = settings.unit;
    final dawn = section.dawn;
    final peak = section.medianPeak;
    final topPeriod =
        section.variablePeriods.isEmpty ? null : section.variablePeriods.first;
    final secondPeriod =
        section.variablePeriods.length > 1 ? section.variablePeriods[1] : null;
    final riseThreshold = glucoseFormatter.value(
      dawn.significantRiseThresholdMmol,
      unit,
    );

    final parts = <String>[];
    if (dawn.consistent) {
      final rise = glucoseFormatter.value(dawn.averageRiseMmol, unit);
      parts.add(
        textBuilder.renderDawn({
          'dawnConsistent': true,
          'windowLabel': dawn.windowLabel,
          'significantDays': dawn.significantDays,
          'observedDays': dawn.observedDays,
          'averageRise': rise.valueLabel,
          'glucoseUnit': rise.unitLabel,
        }),
      );
    } else if (dawn.observedDays == 0) {
      parts.add(
        textBuilder.renderDawn({
          'dawnNotEnough': true,
          'windowLabel': dawn.windowLabel,
        }),
      );
    } else {
      parts.add(
        textBuilder.renderDawn({
          'dawnObserved': true,
          'significantDays': dawn.significantDays,
          'observedDays': dawn.observedDays,
          'riseThreshold': riseThreshold.valueLabel,
          'glucoseUnit': riseThreshold.unitLabel,
        }),
      );
    }

    if (peak != null) {
      final peakValue = glucoseFormatter.value(peak.valueMmol, unit);
      parts.add(
        textBuilder.renderPeak({
          'peakValue': peakValue.valueLabel,
          'glucoseUnit': peakValue.unitLabel,
          'peakTime': _formatMinute(peak.minuteOfDay),
        }),
      );
    }

    if (topPeriod != null && secondPeriod != null) {
      parts.add(
        textBuilder.renderVariability({
          'topPeriod': topPeriod.label,
          'topCv': topPeriod.cv.toStringAsFixed(0),
          'secondPeriod': secondPeriod.label.toLowerCase(),
          'secondCv': secondPeriod.cv.toStringAsFixed(0),
        }),
      );
    } else if (topPeriod != null) {
      parts.add(
        textBuilder.renderVariability({
          'topPeriod': topPeriod.label,
          'topCv': topPeriod.cv.toStringAsFixed(0),
        }),
      );
    } else {
      parts.add(textBuilder.renderVariability({'notEnoughData': true}));
    }

    return parts.join(' ');
  }

  String _formatMinute(int minuteOfDay) {
    final hour = minuteOfDay ~/ 60;
    final minute = minuteOfDay % 60;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}
