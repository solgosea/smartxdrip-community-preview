import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/statistics/application/text/statistics_agp_text_builder.dart';
import 'package:smart_xdrip/plugins/statistics/application/text/statistics_heatmap_text_builder.dart';
import 'package:smart_xdrip/plugins/statistics/application/text/statistics_metrics_text_builder.dart';
import 'package:smart_xdrip/plugins/statistics/application/text/statistics_tir_text_builder.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_heatmap_tag.dart';

void main() {
  test('statistics metrics text renders from templates', () {
    const builder = StatisticsMetricsTextBuilder();

    expect(builder.header('LAST 14 DAYS'), 'KEY METRICS - LAST 14 DAYS');
    expect(builder.tirLabel(), 'Time in Range');
    expect(builder.averageLabel(), 'Avg Glucose');
    expect(builder.cvLabel(), 'Variability CV');
    expect(builder.sdLabel(), 'Std Deviation');
  });

  test('statistics TIR text renders from templates', () {
    const builder = StatisticsTirTextBuilder();

    expect(builder.lowLegend('4'), 'Low 4%');
    expect(builder.inRangeLegend('72'), 'In range 72%');
    expect(builder.highLegend('20'), 'High 20%');
    expect(builder.veryHighLegend('4'), 'Very high 4%');
    expect(builder.veryLowExtreme('<3.0'), 'Very Low <3.0');
    expect(builder.veryHighExtreme('>13.9'), 'Very High >13.9');
  });

  test('statistics heatmap and AGP guidance text renders from templates', () {
    const heatmap = StatisticsHeatmapTextBuilder();
    const agp = StatisticsAgpTextBuilder();

    expect(heatmap.title(), 'Hourly TIR heatmap');
    expect(heatmap.tagLabel(StatisticsHeatmapTag.inTarget), 'in target');
    expect(
      heatmap.tagLabel(StatisticsHeatmapTag.belowTarget),
      'below target',
    );
    expect(
      heatmap.tagLabel(StatisticsHeatmapTag.needsAttention),
      'needs attention',
    );
    expect(
      agp.renderNotEnoughWindowGuidance(),
      'AGP is more meaningful with 7+ days of data.',
    );
  });
}
