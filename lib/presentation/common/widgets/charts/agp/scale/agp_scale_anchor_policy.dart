import 'dart:math';

import '../../../../../../application/analysis/analysis_facade.dart';
import 'agp_scale_anchor.dart';

class AgpScaleAnchorPolicy {
  const AgpScaleAnchorPolicy();

  AgpScaleAnchor fromSlots({
    required List<AnalysisAgpSlot> slots,
    required double low,
    required double high,
  }) {
    final normalizedLow = min(low, high);
    final normalizedHigh = max(low, high);
    final center = (normalizedLow + normalizedHigh) / 2;
    final targetSpan = max((normalizedHigh - normalizedLow).abs(), 1.0);
    final values = <double>[normalizedLow, normalizedHigh, center];
    for (final slot in slots) {
      values
        ..add(slot.p10)
        ..add(slot.p25)
        ..add(slot.p50)
        ..add(slot.p75)
        ..add(slot.p90);
    }
    final dataMin = values.reduce(min);
    final dataMax = values.reduce(max);
    final lower = _niceFloor(
        max(0, min(dataMin, normalizedLow) - max(targetSpan * 0.20, 0.6)));
    final upper =
        _niceCeil(max(dataMax, normalizedHigh) + max(targetSpan * 0.25, 0.8));

    return AgpScaleAnchor(
      lower: min(lower, normalizedLow),
      low: normalizedLow,
      center: center,
      high: normalizedHigh,
      upper: max(upper, normalizedHigh),
    );
  }

  double _niceFloor(double value) {
    if (value <= 0) return 0;
    return (value * 2).floor() / 2;
  }

  double _niceCeil(double value) {
    return (value * 2).ceil() / 2;
  }
}
