import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_geometry.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_inspection_point.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_inspection_policy.dart';

void main() {
  test('snapToNearestReading returns a real reading and its value band', () {
    final start = DateTime(2026, 1, 1, 8);
    final readings = [
      GlucoseReading(timestamp: start, value: 5.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 5)), value: 10.8),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 10)), value: 6.5),
    ];
    const geometry = GlucoseChartGeometry(
      size: Size(350, 180),
      unit: GlucoseUnit.mmolL,
    );
    final targetX = geometry.xForTime(readings[1].timestamp, readings);

    final point = const GlucoseChartInspectionPolicy().snapToNearestReading(
      readings: readings,
      geometry: geometry,
      localPosition: Offset(targetX + 2, 60),
      lowThreshold: 3.9,
      highThreshold: 10.0,
    );

    expect(point?.reading, same(readings[1]));
    expect(point?.band, GlucoseChartValueBand.high);
  });

  test('bandFor maps low, in-range, and high values', () {
    const policy = GlucoseChartInspectionPolicy();

    expect(
      policy.bandFor(3.1, lowThreshold: 3.9, highThreshold: 10.0),
      GlucoseChartValueBand.low,
    );
    expect(
      policy.bandFor(7.1, lowThreshold: 3.9, highThreshold: 10.0),
      GlucoseChartValueBand.inRange,
    );
    expect(
      policy.bandFor(11.4, lowThreshold: 3.9, highThreshold: 10.0),
      GlucoseChartValueBand.high,
    );
  });
}
