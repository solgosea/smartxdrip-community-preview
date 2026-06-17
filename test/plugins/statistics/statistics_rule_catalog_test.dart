import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_delta_tone.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_dawn_signal.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_heatmap_tag.dart';
import 'package:smart_xdrip/plugins/statistics/engine/rules/agp/statistics_agp_rule_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/engine/rules/heatmap/statistics_heatmap_rule_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/engine/rules/metrics/statistics_metrics_rule_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/engine/rules/tir/statistics_tir_rule_catalog.dart';

void main() {
  test('metrics rules classify deltas and CV state', () {
    const rules = StatisticsMetricsRuleCatalog();

    expect(
      rules.deltaTone(5, higherIsBetter: true),
      StatisticsDeltaToneSignal.up,
    );
    expect(
      rules.deltaTone(5, higherIsBetter: false),
      StatisticsDeltaToneSignal.down,
    );
    expect(
      rules.deltaTone(0.01, higherIsBetter: true),
      StatisticsDeltaToneSignal.flat,
    );
    expect(rules.isCvStable(35.9), isTrue);
    expect(rules.isCvStable(36), isFalse);
  });

  test('heatmap rules classify TIR buckets', () {
    const rules = StatisticsHeatmapRuleCatalog();

    expect(rules.tagFor(70), StatisticsHeatmapTag.inTarget);
    expect(rules.tagFor(55), StatisticsHeatmapTag.belowTarget);
    expect(rules.tagFor(54.9), StatisticsHeatmapTag.needsAttention);
  });

  test('AGP rules classify guidance and annotation visibility', () {
    const rules = StatisticsAgpRuleCatalog();
    final oneDay = StatisticsAnalysisWindowCatalog.byId(
      StatisticsAnalysisWindowId.last24Hours,
    );
    final sevenDays = StatisticsAnalysisWindowCatalog.byId(
      StatisticsAnalysisWindowId.last7Days,
    );

    expect(rules.showGuidance(oneDay), isTrue);
    expect(rules.showGuidance(sevenDays), isFalse);
    expect(rules.showDawnAnnotation(StatisticsDawnSignal.empty), isFalse);
    expect(
      rules.showDawnAnnotation(
        const StatisticsDawnSignal(
          consistent: true,
          averageRiseMmol: 1.4,
          significantDays: 8,
          observedDays: 10,
          windowLabel: '04:00-07:00',
          significantRiseThresholdMmol: 1.2,
        ),
      ),
      isTrue,
    );
  });

  test('TIR rules convert percent to daily minutes', () {
    const rules = StatisticsTirRuleCatalog();

    expect(rules.minutesPerDay(50), 720);
    expect(rules.minutesPerDay(1), 14);
  });
}
