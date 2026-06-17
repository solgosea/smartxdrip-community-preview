import '../../../domain/rules/statistics_rule_catalog.dart';
import '../../../domain/rules/statistics_rule_definition.dart';
import '../../../domain/rules/statistics_rule_group.dart';
import '../../../domain/rules/statistics_rule_id.dart';

class StatisticsTirRuleCatalog implements StatisticsRuleCatalog {
  const StatisticsTirRuleCatalog();

  @override
  List<StatisticsRuleDefinition> get definitions => const [
        StatisticsRuleDefinition(
          id: StatisticsRuleId.tirExtreme,
          group: StatisticsRuleGroup.tir,
          description:
              'Converts very-low and very-high percentages to daily minutes.',
        ),
      ];

  int minutesPerDay(double percent) => (percent / 100 * 1440).round();
}
