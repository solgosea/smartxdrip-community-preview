import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_service.dart';
import 'package:smart_xdrip/plugins/explore/report/controllers/report_controller.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_period.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_section.dart';
import 'package:smart_xdrip/plugins/explore/report/pdf/glucose_report_pdf_builder.dart';

void main() {
  test('generates non-empty AGP-style PDF bytes', () async {
    final now = DateTime(2026, 6, 5, 9);
    final readings = <GlucoseReading>[
      for (var i = 0; i < 14 * 24 * 12; i++)
        GlucoseReading(
          timestamp: now.subtract(Duration(minutes: i * 5)),
          value: 6.8 + (i % 48) / 48,
        ),
    ];
    final viewModel = const ReportService().buildViewModel(
      readings: readings,
      settings: const AppSettings(),
      period: ReportPeriod.days14,
      sections: [
        for (final section in ReportController.defaultSections)
          if (section.key == ReportSectionKey.periodAnalysis ||
              section.key == ReportSectionKey.episodesSummary)
            section.copyWith(enabled: true)
          else
            section,
      ],
      generatedAt: now,
    );

    final bytes = await const GlucoseReportPdfBuilder().build(viewModel);

    expect(bytes.length, greaterThan(1000));
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });
}
