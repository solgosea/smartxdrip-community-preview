class StatisticsDawnSignal {
  final bool consistent;
  final double averageRiseMmol;
  final int significantDays;
  final int observedDays;
  final String windowLabel;
  final double significantRiseThresholdMmol;

  const StatisticsDawnSignal({
    required this.consistent,
    required this.averageRiseMmol,
    required this.significantDays,
    required this.observedDays,
    required this.windowLabel,
    required this.significantRiseThresholdMmol,
  });

  static const empty = StatisticsDawnSignal(
    consistent: false,
    averageRiseMmol: 0,
    significantDays: 0,
    observedDays: 0,
    windowLabel: '04:00-07:00',
    significantRiseThresholdMmol: 1.2,
  );
}
