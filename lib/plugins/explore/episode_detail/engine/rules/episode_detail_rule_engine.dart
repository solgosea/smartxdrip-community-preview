import '../../domain/rules/episode_detail_rule_output.dart';

class EpisodeDetailRuleEngine {
  const EpisodeDetailRuleEngine();

  EpisodeDetailRuleOutput<T> output<T>({
    required String ruleId,
    required T value,
  }) {
    return EpisodeDetailRuleOutput<T>(ruleId: ruleId, value: value);
  }
}
