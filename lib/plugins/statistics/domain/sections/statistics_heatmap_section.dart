import '../statistics_heatmap_tag.dart';

class StatisticsHeatmapCell {
  final int hour;
  final double tirPct;
  final StatisticsHeatmapTag tag;

  const StatisticsHeatmapCell({
    required this.hour,
    required this.tirPct,
    required this.tag,
  });
}

class StatisticsHeatmapSection {
  final List<StatisticsHeatmapCell> cells;
  final List<String> labels;

  const StatisticsHeatmapSection({
    required this.cells,
    required this.labels,
  });
}
