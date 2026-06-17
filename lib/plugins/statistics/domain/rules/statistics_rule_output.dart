import 'statistics_rule_id.dart';

class StatisticsRuleOutput<T> {
  final StatisticsRuleId ruleId;
  final T value;

  const StatisticsRuleOutput({
    required this.ruleId,
    required this.value,
  });
}
