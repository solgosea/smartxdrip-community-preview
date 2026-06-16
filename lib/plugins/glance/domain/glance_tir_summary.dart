class GlanceTirSummary {
  final double? tirPercent;
  final int readingCount;

  const GlanceTirSummary({
    required this.tirPercent,
    required this.readingCount,
  });

  const GlanceTirSummary.unavailable()
      : tirPercent = null,
        readingCount = 0;

  bool get isAvailable => tirPercent != null && readingCount > 0;

  String get percentLabel {
    final value = tirPercent;
    if (value == null) return '--';
    return '${value.round()}%';
  }

  String get compactLabel => 'TIR $percentLabel';

  String get fullLabel => 'TIR 24H $percentLabel';
}
