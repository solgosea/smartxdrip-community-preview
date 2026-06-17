import '../../../../../engine/statistics/tir_calculator.dart';
import '../report_period_segment.dart';

class ReportPeriodAnalysisRow {
  final ReportPeriodSegment segment;
  final TirResult tir;
  final double peak;

  const ReportPeriodAnalysisRow({
    required this.segment,
    required this.tir,
    required this.peak,
  });
}

class ReportPeriodAnalysisSection {
  final List<ReportPeriodAnalysisRow> rows;
  final ReportPeriodAnalysisRow? best;
  final ReportPeriodAnalysisRow? mostVariable;

  const ReportPeriodAnalysisSection({
    required this.rows,
    required this.best,
    required this.mostVariable,
  });
}
