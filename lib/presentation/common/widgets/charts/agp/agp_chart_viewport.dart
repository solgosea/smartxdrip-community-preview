import 'dart:math';

import '../../../../../application/analysis/analysis_facade.dart';

class AgpChartViewport {
  final double minMmol;
  final double maxMmol;
  final List<double> referenceLabelsMmol;

  const AgpChartViewport({
    required this.minMmol,
    required this.maxMmol,
    required this.referenceLabelsMmol,
  });

  factory AgpChartViewport.fromSlots({
    required List<AnalysisAgpSlot> slots,
    required double low,
    required double high,
  }) {
    final values = <double>[low, high];
    for (final slot in slots) {
      values
        ..add(slot.p10)
        ..add(slot.p90);
    }

    final dataMin = values.reduce(min);
    final dataMax = values.reduce(max);
    final targetCenter = (low + high) / 2;
    final targetSpan = (high - low).abs();
    final minimumSpan = targetSpan * 2.2;

    var minMmol = dataMin - max(targetSpan * 0.25, 0.8);
    var maxMmol = dataMax + max(targetSpan * 0.30, 1.0);
    if (maxMmol - minMmol < minimumSpan) {
      final halfSpan = minimumSpan / 2;
      minMmol = min(minMmol, targetCenter - halfSpan);
      maxMmol = max(maxMmol, targetCenter + halfSpan);
    }

    minMmol = _niceFloor(max(0, minMmol));
    maxMmol = _niceCeil(maxMmol);

    final referenceLabels = <double>{
      low,
      targetCenter,
      high,
      maxMmol,
    }.where((value) => value >= minMmol && value <= maxMmol).toList()
      ..sort();

    return AgpChartViewport(
      minMmol: minMmol,
      maxMmol: maxMmol,
      referenceLabelsMmol: referenceLabels,
    );
  }

  static double _niceFloor(double value) {
    if (value <= 0) return 0;
    return (value * 2).floor() / 2;
  }

  static double _niceCeil(double value) {
    return (value * 2).ceil() / 2;
  }
}
