import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/glucose_reading.dart';

class HistorySummarySection {
  final AnalysisTirResult? tir;
  final List<GlucoseReading> readings;

  const HistorySummarySection({
    required this.tir,
    required this.readings,
  });
}
