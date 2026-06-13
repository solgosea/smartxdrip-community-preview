import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_inspection_point.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_trend_arrow_policy.dart';

void main() {
  test('directionFor derives rising and falling directions from local slope',
      () {
    final start = DateTime(2026, 1, 1, 8);
    final rising = [
      GlucoseReading(timestamp: start, value: 6.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 5)), value: 6.4),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 10)), value: 6.9),
    ];
    final falling = [
      GlucoseReading(timestamp: start, value: 7.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 5)), value: 6.5),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 10)), value: 6.1),
    ];
    const policy = GlucoseChartTrendArrowPolicy();

    expect(
      policy.directionFor(rising, 1),
      GlucoseChartTrendDirection.rising,
    );
    expect(
      policy.directionFor(falling, 1),
      GlucoseChartTrendDirection.falling,
    );
  });

  test('arrowFor maps direction to scrub arrows', () {
    const policy = GlucoseChartTrendArrowPolicy();

    expect(policy.arrowFor(GlucoseChartTrendDirection.rising), '↗');
    expect(policy.arrowFor(GlucoseChartTrendDirection.flat), '→');
    expect(policy.arrowFor(GlucoseChartTrendDirection.falling), '↘');
  });
}
