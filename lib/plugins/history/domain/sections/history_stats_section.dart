import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/glucose_reading.dart';

class HistoryStatsSection {
  final AnalysisTirResult? tir;
  final List<GlucoseReading> readings;

  const HistoryStatsSection({
    required this.tir,
    required this.readings,
  });
}
