class FloatingGlanceSparklinePoint {
  final double valueMmol;
  final int minutesAgo;

  const FloatingGlanceSparklinePoint({
    required this.valueMmol,
    required this.minutesAgo,
  });

  Map<String, Object> toMap() {
    return {
      'valueMmol': valueMmol,
      'minutesAgo': minutesAgo,
    };
  }
}
