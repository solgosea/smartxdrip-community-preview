import '../../domain/entities/glucose_reading.dart';
import '../../domain/entities/analysis_results.dart';
import '../statistics/tir_calculator.dart';

class GlucotypeClassifier {
  static GlucotypeResult classify(List<GlucoseReading> readings14d) {
    final tir = TirCalculator.calculate(readings14d);

    // Daily peak average
    final Map<String, double> dayPeaks = {};
    for (final r in readings14d) {
      final key = '${r.timestamp.year}-${r.timestamp.month}-${r.timestamp.day}';
      dayPeaks.update(key, (v) => v > r.value ? v : r.value,
          ifAbsent: () => r.value);
    }
    final dailyPeakAvg = dayPeaks.isEmpty
        ? 0.0
        : dayPeaks.values.reduce((a, b) => a + b) / dayPeaks.length;

    GlucotypeLevel level;
    if (dailyPeakAvg < 8.5 && tir.cv < 25) {
      level = GlucotypeLevel.low;
    } else if (dailyPeakAvg > 10.5 || tir.cv > 36) {
      level = GlucotypeLevel.severe;
    } else {
      level = GlucotypeLevel.moderate;
    }

    return GlucotypeResult(
      level: level,
      dailyPeakAvg: dailyPeakAvg,
      cv: tir.cv,
      basedOn: '14 days',
    );
  }
}
