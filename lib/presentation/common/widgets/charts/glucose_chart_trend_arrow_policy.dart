import '../../../../domain/entities/glucose_reading.dart';
import 'glucose_chart_inspection_point.dart';

class GlucoseChartTrendArrowPolicy {
  final double risingThresholdMmolPerMin;
  final double fallingThresholdMmolPerMin;

  const GlucoseChartTrendArrowPolicy({
    this.risingThresholdMmolPerMin = 0.03,
    this.fallingThresholdMmolPerMin = -0.03,
  });

  GlucoseChartTrendDirection directionFor(
    List<GlucoseReading> readings,
    int index,
  ) {
    if (readings.isEmpty || index < 0 || index >= readings.length) {
      return GlucoseChartTrendDirection.flat;
    }

    final explicitRate = readings[index].ratePerMin;
    final rate = explicitRate ?? _localSlope(readings, index);
    if (rate > risingThresholdMmolPerMin) {
      return GlucoseChartTrendDirection.rising;
    }
    if (rate < fallingThresholdMmolPerMin) {
      return GlucoseChartTrendDirection.falling;
    }
    return GlucoseChartTrendDirection.flat;
  }

  double _localSlope(List<GlucoseReading> readings, int index) {
    if (readings.length < 2) return 0;
    final left = readings[index == 0 ? 0 : index - 1];
    final right = readings[index == readings.length - 1 ? index : index + 1];
    final minutes = right.timestamp.difference(left.timestamp).inSeconds / 60;
    if (minutes <= 0) return 0;
    return (right.value - left.value) / minutes;
  }

  String arrowFor(GlucoseChartTrendDirection direction) {
    return switch (direction) {
      GlucoseChartTrendDirection.rising => '↗',
      GlucoseChartTrendDirection.flat => '→',
      GlucoseChartTrendDirection.falling => '↘',
    };
  }
}
