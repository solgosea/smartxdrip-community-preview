class GlanceChartPayload {
  final List<double> trendValues;
  final double targetLowMmol;
  final double targetHighMmol;

  const GlanceChartPayload({
    required this.trendValues,
    required this.targetLowMmol,
    required this.targetHighMmol,
  });
}
