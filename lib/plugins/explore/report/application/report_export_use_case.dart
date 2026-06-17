import '../models/report_view_model.dart';
import '../services/report_export_service.dart';

class ReportExportUseCase {
  final ReportExportService exportService;

  const ReportExportUseCase({
    this.exportService = const ReportExportService(),
  });

  Future<void> execute(
    ReportViewModel viewModel, {
    required ReportExportAction action,
  }) {
    return exportService.export(viewModel, action: action);
  }
}
