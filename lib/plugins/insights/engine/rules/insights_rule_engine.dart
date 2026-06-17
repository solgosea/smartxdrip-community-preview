import '../../domain/rules/insights_rule_output.dart';

class InsightsRuleEngine {
  const InsightsRuleEngine();

  InsightsRuleOutput<T> output<T>({
    required String ruleId,
    required T value,
  }) {
    return InsightsRuleOutput<T>(
      ruleId: ruleId,
      value: value,
    );
  }
}
