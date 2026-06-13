import '../axis/agp_axis_tick.dart';
import '../agp_chart_viewport.dart';
import 'agp_y_scale.dart';

class AgpLinearYScale implements AgpYScale {
  final double minMmol;
  final double maxMmol;

  @override
  final List<AgpAxisTick> ticks;

  const AgpLinearYScale({
    required this.minMmol,
    required this.maxMmol,
    required this.ticks,
  });

  factory AgpLinearYScale.fromViewport(AgpChartViewport viewport) {
    return AgpLinearYScale(
      minMmol: viewport.minMmol,
      maxMmol: viewport.maxMmol,
      ticks: viewport.referenceLabelsMmol
          .map((value) => AgpAxisTick(mmol: value, primary: true))
          .toList(),
    );
  }

  @override
  double yForMmol({
    required double mmol,
    required double top,
    required double bottom,
  }) {
    final span = maxMmol - minMmol;
    if (span <= 0) return bottom;
    final t = ((mmol - minMmol) / span).clamp(0.0, 1.0);
    return bottom - t * (bottom - top);
  }

  @override
  double mmolForY({
    required double y,
    required double top,
    required double bottom,
  }) {
    final span = maxMmol - minMmol;
    if (span <= 0) return minMmol;
    final t = ((bottom - y) / (bottom - top)).clamp(0.0, 1.0);
    return minMmol + t * span;
  }
}
