import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../domain/sections/statistics_agp_section.dart';
import '../domain/sections/statistics_heatmap_section.dart';
import '../domain/sections/statistics_metrics_section.dart';
import '../domain/sections/statistics_period_section.dart';
import '../domain/sections/statistics_tir_breakdown_section.dart';

class StatisticsEngineOutput {
  final AppSettings settings;
  final StatisticsPeriodSection periodSection;
  final StatisticsMetricsSection metricsSection;
  final StatisticsTirBreakdownSection tirBreakdownSection;
  final StatisticsAgpSection agpSection;
  final StatisticsHeatmapSection heatmapSection;

  const StatisticsEngineOutput({
    required this.settings,
    required this.periodSection,
    required this.metricsSection,
    required this.tirBreakdownSection,
    required this.agpSection,
    required this.heatmapSection,
  });
}
