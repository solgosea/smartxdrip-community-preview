import 'package:smart_xdrip/domain/insight/narrative_insight.dart';

import '../../domain/sections/insights_patterns_section.dart';
import '../rules/patterns/insights_pattern_rule_catalog.dart';

class InsightsPatternsSectionBuilder {
  final InsightsPatternRuleCatalog rules;

  const InsightsPatternsSectionBuilder({
    this.rules = const InsightsPatternRuleCatalog(),
  });

  InsightsPatternsSection build(List<NarrativeInsight> insights) {
    final rows = [...insights]
      ..sort((a, b) => a.generatedAt.compareTo(b.generatedAt));
    return InsightsPatternsSection(
      items: rows
          .map(
            (insight) => InsightsPatternItem(
              kind: rules.kindFor(insight.type),
              textType: rules.textTypeFor(insight.type),
              facts: insight.facts,
              fallbackTitle: insight.title ?? '',
              fallbackBody: insight.body,
              fallbackFooter: insight.footer ?? '',
              generatedAt: insight.generatedAt,
            ),
          )
          .toList(growable: false),
    );
  }
}
