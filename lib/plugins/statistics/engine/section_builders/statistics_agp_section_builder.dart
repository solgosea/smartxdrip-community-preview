import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/sections/statistics_agp_section.dart';
import '../../domain/statistics_analysis_window.dart';
import '../../domain/statistics_dawn_signal.dart';
import '../../domain/statistics_period_variability.dart';
import '../rules/agp/statistics_agp_rule_catalog.dart';

class StatisticsAgpSectionBuilder {
  final StatisticsAgpRuleCatalog rules;

  const StatisticsAgpSectionBuilder({
    this.rules = const StatisticsAgpRuleCatalog(),
  });

  StatisticsAgpSection build({
    required StatisticsAnalysisWindow window,
    required List<GlucoseReading> readings,
    required List<AnalysisAgpSlot> slots,
    required StatisticsDawnSignal dawn,
    required List<StatisticsPeriodVariability> variablePeriods,
  }) {
    return StatisticsAgpSection(
      window: window,
      readings: readings,
      slots: slots,
      dawn: dawn,
      medianPeak: _medianPeak(slots),
      variablePeriods: variablePeriods,
      showGuidance: rules.showGuidance(window),
      showDawnAnnotation: rules.showDawnAnnotation(dawn),
    );
  }

  StatisticsMedianPeak? _medianPeak(List<AnalysisAgpSlot> slots) {
    if (slots.isEmpty) return null;
    var best = slots.first;
    for (final slot in slots.skip(1)) {
      if (slot.p50 > best.p50) best = slot;
    }
    return StatisticsMedianPeak(
      minuteOfDay: best.minuteOfDay,
      valueMmol: best.p50,
    );
  }
}
