import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../domain/sections/history_stats_section.dart';

class HistoryStatsSectionBuilder {
  const HistoryStatsSectionBuilder();

  HistoryStatsSection build({
    required AnalysisTirResult? tir,
    required List<GlucoseReading> readings,
  }) {
    return HistoryStatsSection(tir: tir, readings: readings);
  }
}
