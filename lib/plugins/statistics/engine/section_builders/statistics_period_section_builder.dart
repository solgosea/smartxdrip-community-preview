import '../../domain/sections/statistics_period_section.dart';
import '../../domain/statistics_analysis_window.dart';

class StatisticsPeriodSectionBuilder {
  const StatisticsPeriodSectionBuilder();

  StatisticsPeriodSection build({
    required StatisticsAnalysisWindow selectedWindow,
    required List<StatisticsAnalysisWindow> windows,
  }) {
    return StatisticsPeriodSection(
      selectedWindow: selectedWindow,
      metricsHeader: 'KEY METRICS - ${selectedWindow.headerLabel}',
      options: windows
          .map(
            (window) => StatisticsPeriodOption(
              id: window.id,
              label: window.label,
              selected: window.id == selectedWindow.id,
            ),
          )
          .toList(growable: false),
    );
  }
}
