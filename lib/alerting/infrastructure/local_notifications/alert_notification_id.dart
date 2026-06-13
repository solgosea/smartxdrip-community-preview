class AlertNotificationId {
  const AlertNotificationId();

  /// Android notification ids must be stable across isolates and app restarts.
  /// Dart's String.hashCode is not a persistence boundary, so use a tiny FNV-1a
  /// 31-bit hash instead.
  int fromAlertEventId(String alertEventId) {
    var hash = 0x811c9dc5;
    for (final unit in alertEventId.codeUnits) {
      hash ^= unit;
      hash = (hash * 0x01000193) & 0xffffffff;
    }
    return hash & 0x7fffffff;
  }
}
