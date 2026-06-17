enum InsightsMiniStatTone { neutral, positive, warning }

class InsightsMiniStat {
  final String value;
  final String labelType;
  final InsightsMiniStatTone tone;

  const InsightsMiniStat({
    required this.value,
    required this.labelType,
    this.tone = InsightsMiniStatTone.neutral,
  });
}
