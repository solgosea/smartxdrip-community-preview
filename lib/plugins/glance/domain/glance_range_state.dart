enum GlanceRangeState {
  inRange('in_range'),
  high('high'),
  low('low'),
  stale('stale'),
  unknown('unknown');

  final String code;

  const GlanceRangeState(this.code);
}
