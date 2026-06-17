class InsightsRuleOutput<T> {
  final String ruleId;
  final T value;

  const InsightsRuleOutput({
    required this.ruleId,
    required this.value,
  });
}
