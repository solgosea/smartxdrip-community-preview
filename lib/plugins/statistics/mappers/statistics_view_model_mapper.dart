import '../engine/statistics_engine_output.dart';
import '../models/statistics_view_model.dart';
import 'statistics_agp_view_model_mapper.dart';
import 'statistics_heatmap_view_model_mapper.dart';
import 'statistics_metrics_view_model_mapper.dart';
import 'statistics_tir_view_model_mapper.dart';

class StatisticsViewModelMapper {
  final StatisticsMetricsViewModelMapper metricsMapper;
  final StatisticsTirViewModelMapper tirMapper;
  final StatisticsAgpViewModelMapper agpMapper;
  final StatisticsHeatmapViewModelMapper heatmapMapper;

  const StatisticsViewModelMapper({
    this.metricsMapper = const StatisticsMetricsViewModelMapper(),
    this.tirMapper = const StatisticsTirViewModelMapper(),
    this.agpMapper = const StatisticsAgpViewModelMapper(),
    this.heatmapMapper = const StatisticsHeatmapViewModelMapper(),
  });

  StatisticsViewModel map(StatisticsEngineOutput output) {
    final period = output.periodSection;
    final windowLabel = period.selectedWindow.label;
    return StatisticsViewModel(
      selectedWindowId: period.selectedWindow.id,
      periodOptions: period.options
          .map(
            (option) => StatisticsPeriodOptionViewModel(
              id: option.id,
              label: option.label,
              selected: option.selected,
            ),
          )
          .toList(growable: false),
      metricsHeader: metricsMapper.header(period.selectedWindow.headerLabel),
      metrics: metricsMapper.map(
        section: output.metricsSection,
        settings: output.settings,
        previousWindowLabel: windowLabel,
      ),
      tirBreakdown: tirMapper.map(
        section: output.tirBreakdownSection,
        settings: output.settings,
      ),
      agp: agpMapper.map(
        section: output.agpSection,
        settings: output.settings,
      ),
      heatmap: heatmapMapper.map(output.heatmapSection),
    );
  }
}
