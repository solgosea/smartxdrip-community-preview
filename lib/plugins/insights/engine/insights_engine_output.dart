import '../domain/insights_query.dart';
import '../domain/sections/insights_daily_section.dart';
import '../domain/sections/insights_patterns_section.dart';
import '../domain/sections/insights_weekly_section.dart';

class InsightsEngineOutput {
  final InsightsQuery query;
  final InsightsDailySection dailySection;
  final InsightsWeeklySection weeklySection;
  final InsightsPatternsSection patternsSection;

  const InsightsEngineOutput({
    required this.query,
    required this.dailySection,
    required this.weeklySection,
    required this.patternsSection,
  });
}
