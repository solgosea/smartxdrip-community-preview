import '../../domain/report_data_quality.dart';
import '../../domain/sections/report_metrics_section.dart';
import '../../../../../engine/statistics/tir_calculator.dart';

class ReportMetricsSectionBuilder {
  const ReportMetricsSectionBuilder();

  ReportMetricsSection build({
    required TirResult tir,
    required ReportDataQuality quality,
  }) {
    return ReportMetricsSection(tir: tir, quality: quality);
  }
}
