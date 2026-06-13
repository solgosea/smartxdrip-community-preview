import 'dart:ui';

import '../../../../domain/entities/glucose_reading.dart';

enum GlucoseChartValueBand { low, inRange, high }

enum GlucoseChartTrendDirection { rising, flat, falling }

class GlucoseChartInspectionPoint {
  final GlucoseReading reading;
  final Offset offset;
  final GlucoseChartValueBand band;
  final GlucoseChartTrendDirection trend;

  const GlucoseChartInspectionPoint({
    required this.reading,
    required this.offset,
    required this.band,
    required this.trend,
  });
}
