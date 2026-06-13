import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_chart_geometry.dart';

void main() {
  test('nearestIndexByX snaps to real readings on uneven timestamps', () {
    final start = DateTime(2026, 1, 1, 8);
    final readings = [
      GlucoseReading(timestamp: start, value: 6.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 10)), value: 7.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 40)), value: 9.0),
    ];
    const geometry = GlucoseChartGeometry(
      size: Size(350, 180),
      unit: GlucoseUnit.mmolL,
    );

    final middleX = geometry.xForTime(readings[1].timestamp, readings);
    final index = geometry.nearestIndexByX(readings, middleX + 4);

    expect(index, 1);
  });

  test('xForTime uses elapsed time rather than point index spacing', () {
    final start = DateTime(2026, 1, 1, 8);
    final readings = [
      GlucoseReading(timestamp: start, value: 6.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 10)), value: 7.0),
      GlucoseReading(
          timestamp: start.add(const Duration(minutes: 40)), value: 9.0),
    ];
    const geometry = GlucoseChartGeometry(
      size: Size(350, 180),
      unit: GlucoseUnit.mmolL,
    );

    final firstX = geometry.xForTime(readings.first.timestamp, readings);
    final lastX = geometry.xForTime(readings.last.timestamp, readings);
    final middleX = geometry.xForTime(readings[1].timestamp, readings);
    final ratio = (middleX - firstX) / (lastX - firstX);

    expect(ratio, closeTo(0.25, 0.001));
  });

  test(
      'geometry matches the day-view viewport without compressing glucose scale',
      () {
    const geometry = GlucoseChartGeometry(
      size: Size(350, 180),
      unit: GlucoseUnit.mmolL,
      lowThresholdMmol: 3.9,
      highThresholdMmol: 10.0,
    );

    expect(GlucoseChartGeometry.padLeft, 34);
    expect(geometry.right, 342);
    expect(geometry.yForMmol(14.0), closeTo(18, 0.001));
    expect(geometry.yForMmol(2.0), closeTo(152, 0.001));
    expect(geometry.yForMmol(10.0), closeTo(62.667, 0.001));
  });

  test('optional time range pins a 24h chart to 00 through 24', () {
    final start = DateTime(2026, 1, 1);
    final readings = [
      GlucoseReading(
          timestamp: start.add(const Duration(hours: 6)), value: 6.0),
      GlucoseReading(
          timestamp: start.add(const Duration(hours: 12)), value: 7.0),
    ];
    final geometry = GlucoseChartGeometry(
      size: const Size(350, 180),
      unit: GlucoseUnit.mmolL,
      timeRangeStart: start,
      timeRangeEnd: start.add(const Duration(days: 1)),
    );

    expect(geometry.xForTime(start, readings), 34);
    expect(
      geometry.xForTime(start.add(const Duration(days: 1)), readings),
      342,
    );
  });
}
