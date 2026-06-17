import '../../domain/sections/statistics_heatmap_section.dart';
import '../rules/heatmap/statistics_heatmap_rule_catalog.dart';

class StatisticsHeatmapSectionBuilder {
  final StatisticsHeatmapRuleCatalog rules;

  const StatisticsHeatmapSectionBuilder({
    this.rules = const StatisticsHeatmapRuleCatalog(),
  });

  StatisticsHeatmapSection build(List<double> hourlyTir) {
    return StatisticsHeatmapSection(
      cells: List.generate(24, (hour) {
        final value = hourlyTir.isNotEmpty ? hourlyTir[hour] : 0.0;
        return StatisticsHeatmapCell(
          hour: hour,
          tirPct: value,
          tag: rules.tagFor(value),
        );
      }),
      labels: const ['00:00', '06:00', '12:00', '18:00', '24:00'],
    );
  }
}
