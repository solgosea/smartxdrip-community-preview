import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/domain/glucose/glucose_threshold_context.dart';
import 'package:smart_xdrip/engine/statistics/tir_calculator.dart';

class StatisticsTirCalculator {
  const StatisticsTirCalculator();

  TirResult calculate(List<GlucoseReading> readings, AppSettings settings) {
    final context = GlucoseThresholdContext.fromSettings(settings);
    return TirCalculator.calculate(
      readings,
      veryLow: context.veryLow,
      low: context.low,
      high: context.high,
      veryHigh: context.veryHigh,
    );
  }
}
