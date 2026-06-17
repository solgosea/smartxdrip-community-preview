import 'statistics_analysis_window_id.dart';

class StatisticsQuery {
  final String subjectId;
  final StatisticsAnalysisWindowId windowId;

  const StatisticsQuery({
    required this.subjectId,
    required this.windowId,
  });
}
