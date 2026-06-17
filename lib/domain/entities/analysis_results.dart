enum GlucotypeLevel { low, moderate, severe }

class GlucotypeResult {
  final GlucotypeLevel level;
  final double dailyPeakAvg;
  final double cv;
  final String basedOn; // e.g. "14 days"

  const GlucotypeResult({
    required this.level,
    required this.dailyPeakAvg,
    required this.cv,
    required this.basedOn,
  });

  String get label => switch (level) {
        GlucotypeLevel.low => 'Low',
        GlucotypeLevel.moderate => 'Moderate',
        GlucotypeLevel.severe => 'Severe',
      };

  String get description => switch (level) {
        GlucotypeLevel.low =>
          'Stable glucose patterns with minimal out-of-range spikes.',
        GlucotypeLevel.moderate =>
          'Visible glucose peaks with consistent recovery.',
        GlucotypeLevel.severe =>
          'High variability and frequent out-of-range readings.',
      };
}

class PersonalBaseline {
  final double tirLow;
  final double tirHigh;
  final double peakLow;
  final double peakHigh;
  final double cvLow;
  final double cvHigh;
  final double fastingLow;
  final double fastingHigh;
  final double averageMeanLow;
  final double averageMeanHigh;
  final DateTime updatedAt;
  final int daysUsed;

  const PersonalBaseline({
    required this.tirLow,
    required this.tirHigh,
    required this.peakLow,
    required this.peakHigh,
    required this.cvLow,
    required this.cvHigh,
    required this.fastingLow,
    required this.fastingHigh,
    required this.averageMeanLow,
    required this.averageMeanHigh,
    required this.updatedAt,
    required this.daysUsed,
  });
}
