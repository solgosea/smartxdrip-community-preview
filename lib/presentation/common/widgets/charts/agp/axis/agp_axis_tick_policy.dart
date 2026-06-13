import 'agp_axis_tick.dart';

class AgpAxisTickPolicy {
  const AgpAxisTickPolicy();

  List<AgpAxisTick> fromAnchors(
    Iterable<double> anchors, {
    Iterable<double> primary = const [],
  }) {
    final primarySet = primary.map((value) => value.toStringAsFixed(3)).toSet();
    final unique = <String, double>{};
    for (final anchor in anchors) {
      unique[anchor.toStringAsFixed(3)] = anchor;
    }
    final values = unique.values.toList()..sort((a, b) => b.compareTo(a));
    return values
        .map(
          (value) => AgpAxisTick(
            mmol: value,
            primary: primarySet.contains(value.toStringAsFixed(3)),
          ),
        )
        .toList();
  }
}
