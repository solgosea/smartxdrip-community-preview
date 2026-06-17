import '../../../../application/analysis/analysis_facade.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../runtime/report_runtime_snapshot.dart';
import 'report_service.dart';

class ReportSnapshotPreheater {
  final AnalysisFacade Function() facadeProvider;
  final ReportService service;
  final DateTime Function() now;

  const ReportSnapshotPreheater({
    required this.facadeProvider,
    this.service = const ReportService(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<ReportRuntimeSnapshot> preheat({
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
    required String reason,
  }) async {
    final facade = facadeProvider();
    final viewModel = service.buildFromFacade(
      facade: facade,
      period: period,
      sections: sections,
    );
    return ReportRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      period: period,
      sections: sections,
      viewModel: viewModel,
      updatedAt: now(),
      reason: reason,
    );
  }
}
