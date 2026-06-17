import '../../../domain/rules/statistics_rule_catalog.dart';
import '../../../domain/rules/statistics_rule_definition.dart';
import '../../../domain/rules/statistics_rule_group.dart';
import '../../../domain/rules/statistics_rule_id.dart';
import '../../../domain/statistics_delta_tone.dart';
import '../statistics_rule_engine.dart';

class StatisticsMetricsRuleCatalog implements StatisticsRuleCatalog {
  final StatisticsRuleEngine rules;

  const StatisticsMetricsRuleCatalog({
    this.rules = const StatisticsRuleEngine(),
  });

  @override
  List<StatisticsRuleDefinition> get definitions => const [
        StatisticsRuleDefinition(
          id: StatisticsRuleId.metricDeltaTone,
          group: StatisticsRuleGroup.metrics,
          description: 'Classifies metric deltas by preferred direction.',
        ),
        StatisticsRuleDefinition(
          id: StatisticsRuleId.metricCvState,
          group: StatisticsRuleGroup.metrics,
          description: 'Classifies glucose CV below 36% as stable.',
        ),
      ];

  StatisticsDeltaToneSignal deltaTone(
    double delta, {
    required bool higherIsBetter,
  }) {
    return rules.tone(delta, higherIsBetter: higherIsBetter);
  }

  bool isCvStable(double cv) => cv < 36;
}
