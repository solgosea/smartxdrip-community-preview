enum GlanceWidgetTemplate {
  compact('compact', 'Compact', '2x1'),
  trend('trend', 'Trend', '4x2'),
  dashboard('dashboard', 'Dashboard', '4x3'),
  dualUnit('dual_unit', 'Dual Unit', '2x2');

  final String code;
  final String label;
  final String sizeLabel;

  const GlanceWidgetTemplate(this.code, this.label, this.sizeLabel);

  static GlanceWidgetTemplate fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceWidgetTemplate.trend,
    );
  }
}
