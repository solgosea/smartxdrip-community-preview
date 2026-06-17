import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

import '../../domain/sections/insights_daily_section.dart';
import '../../engine/rules/daily/insights_daily_rule_catalog.dart';

class InsightsDailySectionBuilder {
  final InsightsDailyRuleCatalog rules;

  const InsightsDailySectionBuilder({
    this.rules = const InsightsDailyRuleCatalog(),
  });

  InsightsDailySection build(NarrativeInsight? insight) {
    final textType = rules.textTypeFor(insight?.type);
    return InsightsDailySection(
      textType: textType,
      facts: insight?.facts ?? const {},
      fallbackBody: insight?.body ?? '',
      fallbackFooter: insight?.footer ?? '',
      hasData: insight != null && insight.facts.isNotEmpty,
    );
  }
}
