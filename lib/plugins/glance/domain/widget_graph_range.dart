enum GlanceWidgetGraphRange {
  oneHour('1h', '1h', 1),
  fourHours('4h', '4h', 4),
  eightHours('8h', '8h', 8),
  twentyFourHours('24h', '24h', 24);

  final String code;
  final String label;
  final int hours;

  const GlanceWidgetGraphRange(this.code, this.label, this.hours);

  static GlanceWidgetGraphRange fromCode(String? code) {
    final migrated = switch (code) {
      '3h' || 'three_hours' => GlanceWidgetGraphRange.fourHours,
      '6h' || 'six_hours' => GlanceWidgetGraphRange.eightHours,
      '12h' || 'twelve_hours' => GlanceWidgetGraphRange.twentyFourHours,
      _ => null,
    };
    if (migrated != null) return migrated;
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceWidgetGraphRange.fourHours,
    );
  }
}
