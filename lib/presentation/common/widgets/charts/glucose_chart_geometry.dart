import 'dart:math';
import 'dart:ui';

import '../../../../application/glucose_unit/glucose_chart_unit_adapter.dart';
import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';

class GlucoseChartGeometry {
  static const padLeft = 34.0;
  static const padRight = 8.0;
  static const padBottom = 28.0;
  static const padTop = 18.0;

  final Size size;
  final GlucoseUnit unit;
  final double lowThresholdMmol;
  final double highThresholdMmol;
  final DateTime? timeRangeStart;
  final DateTime? timeRangeEnd;
  final GlucoseChartUnitAdapter chartAdapter;

  const GlucoseChartGeometry({
    required this.size,
    required this.unit,
    this.lowThresholdMmol = 3.9,
    this.highThresholdMmol = 10.0,
    this.timeRangeStart,
    this.timeRangeEnd,
    this.chartAdapter = const GlucoseChartUnitAdapter(),
  });

  double get right => size.width - padRight;

  double get bottom => size.height - padBottom;

  double get minY => chartAdapter.minY(unit);

  double get maxY => chartAdapter.maxY(unit);

  double displayValue(double mmol) => chartAdapter.value(mmol, unit);

  double displayThreshold(double mmol) => chartAdapter.threshold(mmol, unit);

  double xForTime(
    DateTime time,
    List<GlucoseReading> readings,
  ) {
    if (readings.length <= 1) return padLeft;
    final first = timeRangeStart ?? readings.first.timestamp;
    final last = timeRangeEnd ?? readings.last.timestamp;
    final total = last.difference(first).inMilliseconds;
    if (total <= 0) return padLeft;
    final delta = time.difference(first).inMilliseconds.toDouble();
    final clamped = delta.clamp(0.0, total.toDouble());
    final usable = size.width - padLeft - padRight;
    return padLeft + (clamped / total) * usable;
  }

  double yForDisplayValue(double value) {
    final range = maxY - minY;
    if (range <= 0) return padTop;
    final usable = size.height - padBottom - padTop;
    final ratio = ((value - minY) / range).clamp(0.0, 1.0);
    return padTop + (1 - ratio) * usable;
  }

  double yForMmol(double mmol) {
    return yForDisplayValue(displayValue(mmol));
  }

  Offset offsetForReading(
    GlucoseReading reading,
    List<GlucoseReading> readings,
  ) {
    return Offset(
      xForTime(reading.timestamp, readings),
      yForMmol(reading.value),
    );
  }

  int nearestIndexByX(
    List<GlucoseReading> readings,
    double x,
  ) {
    if (readings.isEmpty) return -1;
    if (readings.length == 1) return 0;

    final target = x.clamp(padLeft, right);
    var low = 0;
    var high = readings.length - 1;
    while (low < high) {
      final mid = (low + high) >> 1;
      final midX = xForTime(readings[mid].timestamp, readings);
      if (midX < target) {
        low = mid + 1;
      } else {
        high = mid;
      }
    }

    final rightIndex = low;
    final leftIndex = max(0, rightIndex - 1);
    final leftDistance =
        (xForTime(readings[leftIndex].timestamp, readings) - target).abs();
    final rightDistance =
        (xForTime(readings[rightIndex].timestamp, readings) - target).abs();
    return leftDistance <= rightDistance ? leftIndex : rightIndex;
  }
}
