class AgpScaleAnchor {
  final double lower;
  final double low;
  final double center;
  final double high;
  final double upper;

  const AgpScaleAnchor({
    required this.lower,
    required this.low,
    required this.center,
    required this.high,
    required this.upper,
  });

  List<double> get values => [lower, low, center, high, upper];
}
