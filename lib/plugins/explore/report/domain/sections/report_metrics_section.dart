import '../../../../../engine/statistics/tir_calculator.dart';
import '../report_data_quality.dart';

class ReportMetricsSection {
  final TirResult tir;
  final ReportDataQuality quality;

  const ReportMetricsSection({
    required this.tir,
    required this.quality,
  });
}
