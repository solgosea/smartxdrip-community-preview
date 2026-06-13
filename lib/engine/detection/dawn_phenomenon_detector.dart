import '../../domain/entities/glucose_reading.dart';

class DawnPhenomenonDetector {
  static const startHour = 4;
  static const endHour = 7;
  static const minimumReadingsPerWindow = 4;
  static const significantRiseMmol = 1.2;

  static String get windowLabel =>
      '${startHour.toString().padLeft(2, '0')}:00-${endHour.toString().padLeft(2, '0')}:00';

  static List<double> detectDailyRises(List<GlucoseReading> readings) {
    final byDay = <String, List<GlucoseReading>>{};
    for (final reading in readings) {
      if (reading.timestamp.hour >= startHour &&
          reading.timestamp.hour < endHour) {
        final key =
            '${reading.timestamp.year}-${reading.timestamp.month}-${reading.timestamp.day}';
        byDay.putIfAbsent(key, () => []).add(reading);
      }
    }

    return byDay.values
        .where((day) => day.length >= minimumReadingsPerWindow)
        .map((day) {
          day.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          return day.last.value - day.first.value;
        })
        .where((rise) => rise > 0)
        .toList();
  }

  static bool isConsistent(List<GlucoseReading> readings14d) {
    final rises = detectDailyRises(readings14d);
    final significant =
        rises.where((rise) => rise >= significantRiseMmol).length;
    return significant >= 10;
  }

  static double avgRise(List<GlucoseReading> readings14d) {
    final rises = detectDailyRises(readings14d);
    if (rises.isEmpty) return 0;
    return rises.reduce((a, b) => a + b) / rises.length;
  }
}
