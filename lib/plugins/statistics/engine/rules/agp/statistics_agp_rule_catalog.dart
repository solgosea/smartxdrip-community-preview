import '../../../domain/rules/statistics_rule_catalog.dart';
import '../../../domain/rules/statistics_rule_definition.dart';
import '../../../domain/rules/statistics_rule_group.dart';
import '../../../domain/rules/statistics_rule_id.dart';
import '../../../domain/statistics_analysis_window.dart';
import '../../../domain/statistics_dawn_signal.dart';

class StatisticsAgpRuleCatalog implements StatisticsRuleCatalog {
  const StatisticsAgpRuleCatalog();

  @override
  List<StatisticsRuleDefinition> get definitions => const [
        StatisticsRuleDefinition(
          id: StatisticsRuleId.agpGuidance,
          group: StatisticsRuleGroup.agp,
          description: 'Shows AGP guidance for windows shorter than 7 days.',
        ),
        StatisticsRuleDefinition(
          id: StatisticsRuleId.agpDawnAnnotation,
          group: StatisticsRuleGroup.agp,
          description: 'Shows dawn annotation when dawn rise is consistent.',
        ),
      ];

  bool showGuidance(StatisticsAnalysisWindow window) =>
      !window.isAgpRecommended;

  bool showDawnAnnotation(StatisticsDawnSignal dawn) => dawn.consistent;
}
