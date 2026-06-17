import '../../../domain/insights_mini_stat.dart';
import '../../../domain/rules/insights_rule_catalog.dart';
import '../../../domain/rules/insights_rule_definition.dart';
import '../../../domain/rules/insights_rule_group.dart';
import '../../../domain/rules/insights_rule_id.dart';

class InsightsWeeklyRuleCatalog {
  const InsightsWeeklyRuleCatalog();

  InsightsRuleCatalog build() {
    return const InsightsRuleCatalog(
      definitions: [
        InsightsRuleDefinition(
          ruleId: InsightsRuleId.weeklyStatTone,
          group: InsightsRuleGroup.weekly,
        ),
      ],
    );
  }

  InsightsMiniStatTone longestHighTone(Map<String, Object?> facts) {
    return facts['hasLongestHigh'] == true
        ? InsightsMiniStatTone.warning
        : InsightsMiniStatTone.neutral;
  }
}
