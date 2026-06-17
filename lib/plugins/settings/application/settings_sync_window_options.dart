class SettingsSyncWindowOptions {
  static const values = [7, 14, 30, 90];
  static const fallback = 14;
  static const recommended = 14;

  const SettingsSyncWindowOptions._();

  static int normalize(int days) {
    return values.contains(days) ? days : fallback;
  }
}
