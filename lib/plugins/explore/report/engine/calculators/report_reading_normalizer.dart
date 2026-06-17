import '../../../../../domain/entities/glucose_reading.dart';
import '../../domain/report_normalized_readings.dart';

class ReportReadingNormalizer {
  const ReportReadingNormalizer();

  ReportNormalizedReadings normalize(List<GlucoseReading> readings) {
    final byTimestamp = <int, GlucoseReading>{};
    var duplicates = 0;
    for (final reading in readings) {
      final key = reading.timestamp.millisecondsSinceEpoch;
      if (byTimestamp.containsKey(key)) duplicates++;
      byTimestamp[key] = reading;
    }
    final normalized = byTimestamp.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return ReportNormalizedReadings(
      readings: normalized,
      duplicateCount: duplicates,
    );
  }
}
