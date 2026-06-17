class InsightsDailySection {
  final String textType;
  final Map<String, Object?> facts;
  final String fallbackBody;
  final String fallbackFooter;
  final bool hasData;

  const InsightsDailySection({
    required this.textType,
    required this.facts,
    required this.fallbackBody,
    required this.fallbackFooter,
    required this.hasData,
  });
}
