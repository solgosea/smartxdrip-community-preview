class EpisodeDetailRuleOutput<T> {
  final String ruleId;
  final T value;

  const EpisodeDetailRuleOutput({
    required this.ruleId,
    required this.value,
  });
}
