import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class ReportRuntimeSnapshot {
  final String subjectId;
  final ReportPeriod period;
  final List<ReportSectionToggle> sections;
  final ReportViewModel viewModel;
  final DateTime updatedAt;
  final String reason;

  const ReportRuntimeSnapshot({
    required this.subjectId,
    required this.period,
    required this.sections,
    required this.viewModel,
    required this.updatedAt,
    required this.reason,
  });
}
