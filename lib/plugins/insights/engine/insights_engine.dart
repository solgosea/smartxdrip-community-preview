import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

import 'insights_engine_input.dart';
import 'insights_engine_output.dart';
import 'section_builders/insights_daily_section_builder.dart';
import 'section_builders/insights_patterns_section_builder.dart';
import 'section_builders/insights_weekly_section_builder.dart';

class InsightsEngine {
  final InsightsDailySectionBuilder dailySectionBuilder;
  final InsightsWeeklySectionBuilder weeklySectionBuilder;
  final InsightsPatternsSectionBuilder patternsSectionBuilder;

  const InsightsEngine({
    this.dailySectionBuilder = const InsightsDailySectionBuilder(),
    this.weeklySectionBuilder = const InsightsWeeklySectionBuilder(),
    this.patternsSectionBuilder = const InsightsPatternsSectionBuilder(),
  });

  InsightsEngineOutput run(InsightsEngineInput input) {
    final insights = input.insights;
    return InsightsEngineOutput(
      query: input.query,
      dailySection: dailySectionBuilder.build(
        _firstForSlot(insights, InsightSlotCode.dailyBrief),
      ),
      weeklySection: weeklySectionBuilder.build(
        _firstForSlot(insights, InsightSlotCode.weeklyReview),
      ),
      patternsSection: patternsSectionBuilder.build(
        insights
            .where((insight) => insight.slot == InsightSlotCode.patternCard)
            .toList(growable: false),
      ),
    );
  }

  NarrativeInsight? _firstForSlot(
    List<NarrativeInsight> insights,
    InsightSlotCode slot,
  ) {
    final rows = insights.where((insight) => insight.slot == slot).toList()
      ..sort((a, b) => b.generatedAt.compareTo(a.generatedAt));
    return rows.isEmpty ? null : rows.first;
  }
}
