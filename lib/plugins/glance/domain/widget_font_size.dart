enum GlanceWidgetFontSize {
  small('small', 'Small'),
  medium('medium', 'Medium'),
  large('large', 'Large');

  final String code;
  final String label;

  const GlanceWidgetFontSize(this.code, this.label);

  static GlanceWidgetFontSize fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceWidgetFontSize.medium,
    );
  }
}
