import 'insights_rule_group.dart';

class InsightsRuleDefinition {
  final String ruleId;
  final InsightsRuleGroup group;

  const InsightsRuleDefinition({
    required this.ruleId,
    required this.group,
  });
}
