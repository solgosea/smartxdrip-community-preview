import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../application/analysis/analysis_facade.dart';
import '../../../../../application/glucose_unit/glucose_chart_unit_adapter.dart';
import '../../../../../domain/entities/app_settings.dart';
import 'agp_chart_data.dart';
import 'scale/agp_y_scale.dart';

class AgpChartGeometry {
  static const padLeft = 30.0;
  static const padRight = 6.0;
  static const padBottom = 22.0;
  static const padTop = 10.0;

  final Size size;
  final GlucoseUnit unit;
  final AgpYScale yScale;
  final GlucoseChartUnitAdapter adapter;

  const AgpChartGeometry({
    required this.size,
    required this.unit,
    required this.yScale,
    this.adapter = const GlucoseChartUnitAdapter(),
  });

  double get left => padLeft;

  double get right => size.width - padRight;

  double get top => padTop;

  double get bottom => size.height - padBottom;

  double get usableWidth => size.width - padLeft - padRight;

  double get usableHeight => size.height - padBottom - padTop;

  /// Reference design width the stroke/font sizes were tuned against, so
  /// visual thicknesses grow with the canvas like an SVG `viewBox`.
  /// Only thicknesses/sizes use this — positions are NOT scaled.
  static const designWidth = 350.0;

  double get strokeScale => math.min(size.width / designWidth, 1.0);

  double display(double mmol) => adapter.value(mmol, unit);

  double xForMinute(int minuteOfDay) {
    return padLeft + (minuteOfDay.clamp(0, 1440) / 1440.0) * usableWidth;
  }

  double yForMmol(double mmol) => yScale.yForMmol(
        mmol: mmol,
        top: top,
        bottom: bottom,
      );

  double mmolForY(double y) => yScale.mmolForY(
        y: y,
        top: top,
        bottom: bottom,
      );

  int minuteForX(double x) {
    final clamped = x.clamp(left, right).toDouble();
    return (((clamped - left) / usableWidth) * 1440).round().clamp(0, 1440);
  }

  AgpScrubSample? nearestSample({
    required List<AnalysisAgpSlot> slots,
    required double localX,
  }) {
    if (slots.isEmpty) return null;
    final targetMinute = minuteForX(localX);
    var best = slots.first;
    var bestDistance = (best.minuteOfDay - targetMinute).abs();
    for (final slot in slots.skip(1)) {
      final distance = (slot.minuteOfDay - targetMinute).abs();
      if (distance < bestDistance) {
        best = slot;
        bestDistance = distance;
      }
    }
    return sampleForSlot(best);
  }

  AgpScrubSample sampleForSlot(AnalysisAgpSlot slot) {
    final x = xForMinute(slot.minuteOfDay);
    final medianY = yForMmol(slot.p50);
    final highY = yForMmol(slot.p75);
    final lowY = yForMmol(slot.p25);
    return AgpScrubSample(
      minuteOfDay: slot.minuteOfDay,
      median: slot.p50,
      iqrLow: slot.p25,
      iqrHigh: slot.p75,
      medianPoint: Offset(x, medianY),
      iqrTopY: highY,
      iqrBottomY: lowY,
    );
  }
}
