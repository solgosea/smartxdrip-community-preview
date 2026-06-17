import '../../../domain/rules/statistics_rule_catalog.dart';
import '../../../domain/rules/statistics_rule_definition.dart';
import '../../../domain/rules/statistics_rule_group.dart';
import '../../../domain/rules/statistics_rule_id.dart';
import '../../../domain/statistics_heatmap_tag.dart';
import '../statistics_rule_engine.dart';

class StatisticsHeatmapRuleCatalog implements StatisticsRuleCatalog {
  final StatisticsRuleEngine rules;

  const StatisticsHeatmapRuleCatalog({
    this.rules = const StatisticsRuleEngine(),
  });

  @override
  List<StatisticsRuleDefinition> get definitions => const [
        StatisticsRuleDefinition(
          id: StatisticsRuleId.heatmapTag,
          group: StatisticsRuleGroup.heatmap,
          description: 'Classifies hourly TIR into display tags.',
        ),
      ];

  StatisticsHeatmapTag tagFor(double tirPct) => rules.heatmapTag(tirPct);
}
