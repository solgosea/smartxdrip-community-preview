import '../axis/agp_axis_tick.dart';

abstract class AgpYScale {
  List<AgpAxisTick> get ticks;

  double yForMmol({
    required double mmol,
    required double top,
    required double bottom,
  });

  double mmolForY({
    required double y,
    required double top,
    required double bottom,
  });
}
