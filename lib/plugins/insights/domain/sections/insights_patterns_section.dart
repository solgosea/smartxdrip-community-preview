import '../insights_pattern_kind.dart';

class InsightsPatternItem {
  final InsightsPatternKind kind;
  final String textType;
  final Map<String, Object?> facts;
  final String fallbackTitle;
  final String fallbackBody;
  final String fallbackFooter;
  final DateTime generatedAt;

  const InsightsPatternItem({
    required this.kind,
    required this.textType,
    required this.facts,
    required this.fallbackTitle,
    required this.fallbackBody,
    required this.fallbackFooter,
    required this.generatedAt,
  });
}

class InsightsPatternsSection {
  final List<InsightsPatternItem> items;

  const InsightsPatternsSection({
    required this.items,
  });
}
