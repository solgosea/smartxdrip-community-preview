import '../application/text/insights_header_text_builder.dart';
import '../application/text/insights_empty_state_text_builder.dart';
import '../engine/insights_engine_output.dart';
import '../models/insights_view_model.dart';
import 'insights_daily_view_model_mapper.dart';
import 'insights_patterns_view_model_mapper.dart';
import 'insights_weekly_view_model_mapper.dart';

class InsightsViewModelMapper {
  final InsightsHeaderTextBuilder headerTextBuilder;
  final InsightsEmptyStateTextBuilder emptyStateTextBuilder;
  final InsightsDailyViewModelMapper dailyMapper;
  final InsightsWeeklyViewModelMapper weeklyMapper;
  final InsightsPatternsViewModelMapper patternsMapper;

  const InsightsViewModelMapper({
    this.headerTextBuilder = const InsightsHeaderTextBuilder(),
    this.emptyStateTextBuilder = const InsightsEmptyStateTextBuilder(),
    this.dailyMapper = const InsightsDailyViewModelMapper(),
    this.weeklyMapper = const InsightsWeeklyViewModelMapper(),
    this.patternsMapper = const InsightsPatternsViewModelMapper(),
  });

  InsightsViewModel map(InsightsEngineOutput output) {
    final daily = dailyMapper.map(output.dailySection);
    return InsightsViewModel(
      headerDate: headerTextBuilder.date(output.query.anchorTime),
      dailyBrief: daily.body,
      dailyBriefFooter: daily.footer,
      weeklyReview: weeklyMapper.map(output.weeklySection),
      patterns: patternsMapper.map(output.patternsSection),
      patternsEmptyText: emptyStateTextBuilder.noData(),
    );
  }
}
