import '../statistics_delta_tone.dart';

class StatisticsMetricsSection {
  final double tir;
  final double tirDelta;
  final StatisticsDeltaToneSignal tirTone;
  final double meanMmol;
  final double meanDeltaMmol;
  final StatisticsDeltaToneSignal meanTone;
  final double gmi;
  final double cv;
  final double cvDelta;
  final StatisticsDeltaToneSignal cvTone;
  final bool cvStable;
  final double sdMmol;
  final double sdDeltaMmol;
  final StatisticsDeltaToneSignal sdTone;

  const StatisticsMetricsSection({
    required this.tir,
    required this.tirDelta,
    required this.tirTone,
    required this.meanMmol,
    required this.meanDeltaMmol,
    required this.meanTone,
    required this.gmi,
    required this.cv,
    required this.cvDelta,
    required this.cvTone,
    required this.cvStable,
    required this.sdMmol,
    required this.sdDeltaMmol,
    required this.sdTone,
  });
}
