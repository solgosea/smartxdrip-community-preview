import 'dart:ui';

import '../../../../domain/entities/glucose_reading.dart';
import 'glucose_chart_geometry.dart';
import 'glucose_chart_inspection_point.dart';
import 'glucose_chart_trend_arrow_policy.dart';

class GlucoseChartInspectionPolicy {
  final GlucoseChartTrendArrowPolicy trendPolicy;

  const GlucoseChartInspectionPolicy({
    this.trendPolicy = const GlucoseChartTrendArrowPolicy(),
  });

  GlucoseChartInspectionPoint? snapToNearestReading({
    required List<GlucoseReading> readings,
    required GlucoseChartGeometry geometry,
    required Offset localPosition,
    required double lowThreshold,
    required double highThreshold,
  }) {
    if (readings.isEmpty) return null;
    final index = geometry.nearestIndexByX(readings, localPosition.dx);
    if (index < 0) return null;
    final reading = readings[index];
    return GlucoseChartInspectionPoint(
      reading: reading,
      offset: geometry.offsetForReading(reading, readings),
      band: bandFor(
        reading.value,
        lowThreshold: lowThreshold,
        highThreshold: highThreshold,
      ),
      trend: trendPolicy.directionFor(readings, index),
    );
  }

  GlucoseChartValueBand bandFor(
    double mmol, {
    required double lowThreshold,
    required double highThreshold,
  }) {
    if (mmol > highThreshold) return GlucoseChartValueBand.high;
    if (mmol < lowThreshold) return GlucoseChartValueBand.low;
    return GlucoseChartValueBand.inRange;
  }
}
