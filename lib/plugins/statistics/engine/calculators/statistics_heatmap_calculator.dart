import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose/glucose_threshold_context.dart';

class StatisticsHeatmapCalculator {
  const StatisticsHeatmapCalculator();

  List<double> calculateHourlyTir({
    required List<GlucoseReading> readings,
    required AppSettings settings,
  }) {
    final context = GlucoseThresholdContext.fromSettings(settings);
    final hourTir = List<double>.filled(24, 0);
    for (var h = 0; h < 24; h++) {
      final hourReadings =
          readings.where((r) => r.timestamp.hour == h).toList();
      if (hourReadings.isEmpty) continue;
      final inRange =
          hourReadings.where((r) => context.isInRange(r.value)).length;
      hourTir[h] = (inRange / hourReadings.length) * 100;
    }
    return hourTir;
  }
}
