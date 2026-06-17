import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/glucose_reading.dart';

class HistorySummaryCalculator {
  const HistorySummaryCalculator();

  ({AnalysisTirResult? tir, List<GlucoseReading> readings}) calculate({
    required AnalysisTirResult? tir,
    required List<GlucoseReading> readings,
  }) {
    return (tir: tir, readings: readings);
  }
}
