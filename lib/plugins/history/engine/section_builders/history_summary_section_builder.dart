import '../../../../application/analysis/analysis_facade.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../domain/sections/history_summary_section.dart';

class HistorySummarySectionBuilder {
  const HistorySummarySectionBuilder();

  HistorySummarySection build({
    required AnalysisTirResult? tir,
    required List<GlucoseReading> readings,
  }) {
    return HistorySummarySection(tir: tir, readings: readings);
  }
}
