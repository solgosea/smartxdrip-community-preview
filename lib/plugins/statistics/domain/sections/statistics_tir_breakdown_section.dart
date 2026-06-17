class StatisticsTirBreakdownSection {
  final double lowPct;
  final double inRangePct;
  final double highPct;
  final double veryHighPct;
  final double veryLowPct;
  final int veryLowMinutesPerDay;
  final int veryHighMinutesPerDay;

  const StatisticsTirBreakdownSection({
    required this.lowPct,
    required this.inRangePct,
    required this.highPct,
    required this.veryHighPct,
    required this.veryLowPct,
    required this.veryLowMinutesPerDay,
    required this.veryHighMinutesPerDay,
  });
}
