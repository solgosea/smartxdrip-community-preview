import '../../domain/statistics_delta_tone.dart';
import '../../domain/statistics_heatmap_tag.dart';

class StatisticsRuleEngine {
  const StatisticsRuleEngine();

  StatisticsDeltaToneSignal tone(
    double delta, {
    required bool higherIsBetter,
  }) {
    if (delta.abs() < 0.05) return StatisticsDeltaToneSignal.flat;
    final improved = higherIsBetter ? delta > 0 : delta < 0;
    return improved
        ? StatisticsDeltaToneSignal.up
        : StatisticsDeltaToneSignal.down;
  }

  StatisticsHeatmapTag heatmapTag(double tirPct) {
    if (tirPct >= 70) return StatisticsHeatmapTag.inTarget;
    if (tirPct >= 55) return StatisticsHeatmapTag.belowTarget;
    return StatisticsHeatmapTag.needsAttention;
  }
}
