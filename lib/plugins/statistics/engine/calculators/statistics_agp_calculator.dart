import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/engine/statistics/agp_calculator.dart';

class StatisticsAgpCalculator {
  const StatisticsAgpCalculator();

  List<AnalysisAgpSlot> calculate(List<GlucoseReading> readings) {
    if (readings.isEmpty) return const [];
    return AgpCalculator.calculate(readings);
  }
}
