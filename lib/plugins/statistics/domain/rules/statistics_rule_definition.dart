import 'statistics_rule_group.dart';
import 'statistics_rule_id.dart';

class StatisticsRuleDefinition {
  final StatisticsRuleId id;
  final StatisticsRuleGroup group;
  final String description;

  const StatisticsRuleDefinition({
    required this.id,
    required this.group,
    required this.description,
  });
}
