import 'package:smart_xdrip/domain/insight/insight_type_code.dart';

import '../../../domain/insights_pattern_kind.dart';
import '../../../domain/rules/insights_rule_catalog.dart';
import '../../../domain/rules/insights_rule_definition.dart';
import '../../../domain/rules/insights_rule_group.dart';
import '../../../domain/rules/insights_rule_id.dart';
import '../../../domain/text/insights_text_type.dart';

class InsightsPatternRuleCatalog {
  const InsightsPatternRuleCatalog();

  InsightsRuleCatalog build() {
    return const InsightsRuleCatalog(
      definitions: [
        InsightsRuleDefinition(
          ruleId: InsightsRuleId.patternKind,
          group: InsightsRuleGroup.patterns,
        ),
        InsightsRuleDefinition(
          ruleId: InsightsRuleId.patternTextType,
          group: InsightsRuleGroup.patterns,
        ),
      ],
    );
  }

  InsightsPatternKind kindFor(InsightTypeCode type) {
    return switch (type) {
      InsightTypeCode.dawnPattern => InsightsPatternKind.dawn,
      InsightTypeCode.volatilePeriod => InsightsPatternKind.volatility,
      InsightTypeCode.stablePeriod => InsightsPatternKind.stability,
      InsightTypeCode.weekdayGap => InsightsPatternKind.weekday,
      _ => InsightsPatternKind.generic,
    };
  }

  String textTypeFor(InsightTypeCode type) {
    return switch (type) {
      InsightTypeCode.dawnPattern => InsightsTextType.patternDawn,
      InsightTypeCode.volatilePeriod => InsightsTextType.patternVolatile,
      InsightTypeCode.stablePeriod => InsightsTextType.patternStable,
      InsightTypeCode.weekdayGap => InsightsTextType.patternWeekdayGap,
      _ => InsightsTextType.patternNotEnough,
    };
  }
}
