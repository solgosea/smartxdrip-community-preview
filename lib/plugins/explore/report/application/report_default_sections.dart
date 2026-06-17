import '../models/report_section.dart';

class ReportDefaultSections {
  static const values = [
    ReportSectionToggle(
      key: ReportSectionKey.keyMetrics,
      title: 'Key Metrics',
      subtitle: 'TIR, average, wear, CV and GMI',
      enabled: true,
    ),
    ReportSectionToggle(
      key: ReportSectionKey.agpChart,
      title: 'AGP Chart',
      subtitle: '24-hour percentile overlay',
      enabled: true,
    ),
    ReportSectionToggle(
      key: ReportSectionKey.dailyCurves,
      title: 'Daily Curves',
      subtitle: 'Last 14 days with sparse-data marks',
      enabled: true,
    ),
    ReportSectionToggle(
      key: ReportSectionKey.periodAnalysis,
      title: 'Period Analysis',
      subtitle: 'Add day-part pattern summary',
      enabled: false,
    ),
    ReportSectionToggle(
      key: ReportSectionKey.episodesSummary,
      title: 'Episodes Summary',
      subtitle: 'Add low/high episode counts',
      enabled: false,
    ),
  ];
}
