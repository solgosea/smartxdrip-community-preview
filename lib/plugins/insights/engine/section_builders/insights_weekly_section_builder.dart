import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

import '../../domain/insights_mini_stat.dart';
import '../../domain/sections/insights_weekly_section.dart';
import '../../domain/text/insights_text_type.dart';
import '../rules/weekly/insights_weekly_rule_catalog.dart';

class InsightsWeeklySectionBuilder {
  final InsightsWeeklyRuleCatalog rules;

  const InsightsWeeklySectionBuilder({
    this.rules = const InsightsWeeklyRuleCatalog(),
  });

  InsightsWeeklySection build(NarrativeInsight? insight) {
    final facts = insight?.facts ?? const <String, Object?>{};
    return InsightsWeeklySection(
      facts: facts,
      fallbackEyebrow: insight?.eyebrow ?? '',
      fallbackBody: insight?.body ?? '',
      stats: [
        InsightsMiniStat(
          value: _factString(facts, 'tir7'),
          labelType: InsightsTextType.weeklyStatTir,
          tone: InsightsMiniStatTone.positive,
        ),
        InsightsMiniStat(
          value: _factString(facts, 'bestDayShort'),
          labelType: InsightsTextType.weeklyStatBestDay,
        ),
        InsightsMiniStat(
          value: _factString(facts, 'longestHighValue'),
          labelType: InsightsTextType.weeklyStatLongestHigh,
          tone: rules.longestHighTone(facts),
        ),
      ],
      hasData: insight != null && facts.isNotEmpty,
    );
  }

  String _factString(Map<String, Object?> facts, String key) {
    final value = facts[key];
    if (value == null) return '--';
    final text = value.toString();
    return text.isEmpty ? '--' : text;
  }
}
