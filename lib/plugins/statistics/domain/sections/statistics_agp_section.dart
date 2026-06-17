import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../statistics_analysis_window.dart';
import '../statistics_dawn_signal.dart';
import '../statistics_period_variability.dart';

class StatisticsMedianPeak {
  final int minuteOfDay;
  final double valueMmol;

  const StatisticsMedianPeak({
    required this.minuteOfDay,
    required this.valueMmol,
  });
}

class StatisticsAgpSection {
  final StatisticsAnalysisWindow window;
  final List<GlucoseReading> readings;
  final List<AnalysisAgpSlot> slots;
  final StatisticsDawnSignal dawn;
  final StatisticsMedianPeak? medianPeak;
  final List<StatisticsPeriodVariability> variablePeriods;
  final bool showGuidance;
  final bool showDawnAnnotation;

  const StatisticsAgpSection({
    required this.window,
    required this.readings,
    required this.slots,
    required this.dawn,
    required this.medianPeak,
    required this.variablePeriods,
    required this.showGuidance,
    required this.showDawnAnnotation,
  });
}
