enum GlanceNotificationPrivacyMode {
  full('full', 'Show glucose'),
  private('private', 'Private on lock screen');

  final String code;
  final String label;

  const GlanceNotificationPrivacyMode(this.code, this.label);

  static GlanceNotificationPrivacyMode fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => GlanceNotificationPrivacyMode.private,
    );
  }
}
