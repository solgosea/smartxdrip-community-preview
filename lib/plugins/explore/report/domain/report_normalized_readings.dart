import '../../../../domain/entities/glucose_reading.dart';

class ReportNormalizedReadings {
  final List<GlucoseReading> readings;
  final int duplicateCount;

  const ReportNormalizedReadings({
    required this.readings,
    required this.duplicateCount,
  });
}
