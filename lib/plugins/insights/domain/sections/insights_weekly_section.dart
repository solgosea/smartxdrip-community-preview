import '../insights_mini_stat.dart';

class InsightsWeeklySection {
  final Map<String, Object?> facts;
  final String fallbackEyebrow;
  final String fallbackBody;
  final List<InsightsMiniStat> stats;
  final bool hasData;

  const InsightsWeeklySection({
    required this.facts,
    required this.fallbackEyebrow,
    required this.fallbackBody,
    required this.stats,
    required this.hasData,
  });
}
