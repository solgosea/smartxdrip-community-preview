import 'dart:math';

import '../axis/agp_axis_tick.dart';
import '../axis/agp_axis_tick_policy.dart';
import 'agp_scale_anchor.dart';
import 'agp_segment_weight_policy.dart';
import 'agp_y_scale.dart';

class AgpSegmentedYScale implements AgpYScale {
  final AgpScaleAnchor anchors;
  final AgpSegmentWeightPolicy weights;
  final AgpAxisTickPolicy tickPolicy;

  const AgpSegmentedYScale({
    required this.anchors,
    this.weights = const AgpSegmentWeightPolicy.detail(),
    this.tickPolicy = const AgpAxisTickPolicy(),
  });

  @override
  List<AgpAxisTick> get ticks => tickPolicy.fromAnchors(
        anchors.values,
        primary: [anchors.low, anchors.center, anchors.high],
      );

  @override
  double yForMmol({
    required double mmol,
    required double top,
    required double bottom,
  }) {
    final segments = _segments(top: top, bottom: bottom);
    final value = mmol.clamp(anchors.lower, anchors.upper).toDouble();
    for (final segment in segments) {
      if (value >= segment.lowMmol && value <= segment.highMmol) {
        return _lerp(
          segment.lowY,
          segment.highY,
          _fraction(value, segment.lowMmol, segment.highMmol),
        );
      }
    }
    return value < anchors.lower ? bottom : top;
  }

  @override
  double mmolForY({
    required double y,
    required double top,
    required double bottom,
  }) {
    final segments = _segments(top: top, bottom: bottom);
    final value = y.clamp(top, bottom).toDouble();
    for (final segment in segments) {
      final minY = min(segment.lowY, segment.highY);
      final maxY = max(segment.lowY, segment.highY);
      if (value >= minY && value <= maxY) {
        return _lerp(
          segment.lowMmol,
          segment.highMmol,
          _fraction(value, segment.lowY, segment.highY),
        );
      }
    }
    return value >= bottom ? anchors.lower : anchors.upper;
  }

  List<_ScaleSegment> _segments({
    required double top,
    required double bottom,
  }) {
    final totalWeight = weights.lowerToLow +
        weights.lowToCenter +
        weights.centerToHigh +
        weights.highToUpper;
    final height = bottom - top;
    final lowerLowHeight = height * weights.lowerToLow / totalWeight;
    final lowCenterHeight = height * weights.lowToCenter / totalWeight;
    final centerHighHeight = height * weights.centerToHigh / totalWeight;
    final highUpperHeight = height * weights.highToUpper / totalWeight;

    final lowerY = bottom;
    final lowY = lowerY - lowerLowHeight;
    final centerY = lowY - lowCenterHeight;
    final highY = centerY - centerHighHeight;
    final upperY = highY - highUpperHeight;

    return [
      _ScaleSegment(
        lowMmol: anchors.lower,
        highMmol: anchors.low,
        lowY: lowerY,
        highY: lowY,
      ),
      _ScaleSegment(
        lowMmol: anchors.low,
        highMmol: anchors.center,
        lowY: lowY,
        highY: centerY,
      ),
      _ScaleSegment(
        lowMmol: anchors.center,
        highMmol: anchors.high,
        lowY: centerY,
        highY: highY,
      ),
      _ScaleSegment(
        lowMmol: anchors.high,
        highMmol: anchors.upper,
        lowY: highY,
        highY: upperY,
      ),
    ];
  }

  double _fraction(double value, double low, double high) {
    final span = high - low;
    if (span.abs() < 0.0001) return 0;
    return ((value - low) / span).clamp(0.0, 1.0);
  }

  double _lerp(double a, double b, double t) => a + (b - a) * t;
}

class _ScaleSegment {
  final double lowMmol;
  final double highMmol;
  final double lowY;
  final double highY;

  const _ScaleSegment({
    required this.lowMmol,
    required this.highMmol,
    required this.lowY,
    required this.highY,
  });
}
