enum FloatingGlanceOverlayState {
  compact('compact'),
  expanded('expanded');

  final String code;

  const FloatingGlanceOverlayState(this.code);

  static FloatingGlanceOverlayState fromCode(String? code) {
    return values.firstWhere(
      (value) => value.code == code,
      orElse: () => FloatingGlanceOverlayState.compact,
    );
  }
}
