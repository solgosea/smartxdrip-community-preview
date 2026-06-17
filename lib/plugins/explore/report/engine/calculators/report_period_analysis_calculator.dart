import 'dart:math';

import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../../../../engine/statistics/tir_calculator.dart';
import '../../domain/report_period_segment.dart';
import '../../domain/sections/report_period_analysis_section.dart';
import 'report_coverage_calculator.dart';

class ReportPeriodAnalysisCalculator {
  const ReportPeriodAnalysisCalculator();

  static const segments = [
    ReportPeriodSegment('Overnight', 0, 6),
    ReportPeriodSegment('Morning', 6, 12),
    ReportPeriodSegment('Afternoon', 12, 18),
    ReportPeriodSegment('Evening', 18, 24),
  ];

  ReportPeriodAnalysisSection calculate(
    List<GlucoseReading> readings,
    AppSettings settings,
  ) {
    final rows = <ReportPeriodAnalysisRow>[];
    ReportPeriodAnalysisRow? best;
    ReportPeriodAnalysisRow? mostVariable;
    for (final segment in segments) {
      final segmentReadings = readings
          .where((reading) =>
              reading.timestamp.hour >= segment.startHour &&
              reading.timestamp.hour < segment.endHour)
          .toList();
      if (segmentReadings.isEmpty) continue;
      final tir = TirCalculator.calculate(
        segmentReadings,
        low: settings.lowThreshold,
        high: settings.highThreshold,
        veryHigh: settings.veryHighThreshold,
        veryLow: ReportCoverageCalculator.veryLowMmol,
      );
      final peak = segmentReadings.map((reading) => reading.value).reduce(max);
      final row = ReportPeriodAnalysisRow(
        segment: segment,
        tir: tir,
        peak: peak,
      );
      if (best == null || row.tir.tir > best.tir.tir) best = row;
      if (mostVariable == null || row.tir.cv > mostVariable.tir.cv) {
        mostVariable = row;
      }
      rows.add(row);
    }
    return ReportPeriodAnalysisSection(
      rows: rows,
      best: best,
      mostVariable: mostVariable,
    );
  }
}
