import 'package:printing/printing.dart';

import '../models/report_view_model.dart';
import '../pdf/glucose_report_pdf_builder.dart';

enum ReportExportAction { save, share, email }

class ReportExportService {
  final GlucoseReportPdfBuilder pdfBuilder;

  const ReportExportService({
    this.pdfBuilder = const GlucoseReportPdfBuilder(),
  });

  Future<void> export(
    ReportViewModel viewModel, {
    required ReportExportAction action,
  }) async {
    final bytes = await pdfBuilder.build(viewModel);
    final filename =
        'solgoinsight-glucose-report-${viewModel.selectedPeriod.label}.pdf';
    switch (action) {
      case ReportExportAction.save:
        await Printing.layoutPdf(name: filename, onLayout: (_) async => bytes);
      case ReportExportAction.share:
      case ReportExportAction.email:
        await Printing.sharePdf(bytes: bytes, filename: filename);
    }
  }
}
