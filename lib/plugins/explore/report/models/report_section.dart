enum ReportSectionKey {
  keyMetrics,
  agpChart,
  dailyCurves,
  periodAnalysis,
  episodesSummary,
}

class ReportSectionToggle {
  final ReportSectionKey key;
  final String title;
  final String subtitle;
  final bool enabled;

  const ReportSectionToggle({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.enabled,
  });

  ReportSectionToggle copyWith({bool? enabled}) => ReportSectionToggle(
        key: key,
        title: title,
        subtitle: subtitle,
        enabled: enabled ?? this.enabled,
      );
}
