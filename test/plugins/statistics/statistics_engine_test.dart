import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_catalog.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_analysis_window_id.dart';
import 'package:smart_xdrip/plugins/statistics/domain/statistics_heatmap_tag.dart';
import 'package:smart_xdrip/plugins/statistics/engine/statistics_engine.dart';
import 'package:smart_xdrip/plugins/statistics/engine/statistics_engine_input.dart';

void main() {
  test('statistics engine builds section-first output from readings', () {
    final window = StatisticsAnalysisWindowCatalog.byId(
      StatisticsAnalysisWindowId.last24Hours,
    );
    final current = _readings(
      DateTime(2026, 6, 17),
      valueForHour: (hour) => hour == 6 ? 12.0 : 6.0,
    );
    final previous = _readings(
      DateTime(2026, 6, 16),
      valueForHour: (_) => 12.0,
    );

    final output = const StatisticsEngine().run(
      StatisticsEngineInput(
        selectedWindow: window,
        windows: StatisticsAnalysisWindowCatalog.all,
        currentReadings: current,
        previousReadings: previous,
        settings: const AppSettings(),
      ),
    );

    expect(output.periodSection.selectedWindow.id, window.id);
    expect(output.periodSection.options, hasLength(6));
    expect(output.metricsSection.tir, greaterThan(90));
    expect(output.metricsSection.tirDelta, greaterThan(90));
    expect(output.tirBreakdownSection.inRangePct, greaterThan(0));
    expect(output.agpSection.slots, isNotEmpty);
    expect(output.heatmapSection.cells, hasLength(24));
    expect(output.heatmapSection.cells[0].tag, StatisticsHeatmapTag.inTarget);
    expect(
      output.heatmapSection.cells[6].tag,
      StatisticsHeatmapTag.needsAttention,
    );
  });
}

List<GlucoseReading> _readings(
  DateTime day, {
  required double Function(int hour) valueForHour,
}) {
  return [
    for (var hour = 0; hour < 24; hour++)
      GlucoseReading(
        timestamp: DateTime(day.year, day.month, day.day, hour),
        value: valueForHour(hour),
      ),
  ];
}
