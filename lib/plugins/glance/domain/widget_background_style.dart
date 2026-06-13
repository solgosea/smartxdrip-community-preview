enum GlanceWidgetBackgroundStyle {
  dark('dark', 'Dark'),
  light('light', 'Light'),
  transparent('transparent', 'Transparent');

  final String code;
  final String label;

  const GlanceWidgetBackgroundStyle(this.code, this.label);

  static GlanceWidgetBackgroundStyle fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceWidgetBackgroundStyle.dark,
    );
  }
}
