import 'package:smart_xdrip/domain/insight/insight_type_code.dart';

import '../../../domain/rules/insights_rule_catalog.dart';
import '../../../domain/rules/insights_rule_definition.dart';
import '../../../domain/rules/insights_rule_group.dart';
import '../../../domain/rules/insights_rule_id.dart';
import '../../../domain/text/insights_text_type.dart';

class InsightsDailyRuleCatalog {
  const InsightsDailyRuleCatalog();

  InsightsRuleCatalog build() {
    return const InsightsRuleCatalog(
      definitions: [
        InsightsRuleDefinition(
          ruleId: InsightsRuleId.dailyType,
          group: InsightsRuleGroup.daily,
        ),
      ],
    );
  }

  String textTypeFor(InsightTypeCode? type) {
    return switch (type) {
      InsightTypeCode.dailyCompleteDay => InsightsTextType.dailyCompleteDay,
      _ => InsightsTextType.dailyNotEnoughData,
    };
  }
}
