import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/report/application/report_service.dart';
import 'package:smart_xdrip/plugins/explore/report/controllers/report_controller.dart';
import 'package:smart_xdrip/plugins/explore/report/models/report_period.dart';

void main() {
  test('builds AGP report metrics from canonical glucose readings', () {
    final now = DateTime(2026, 6, 5, 9);
    final readings = _readings(now, days: 30);
    final viewModel = const ReportService().buildViewModel(
      readings: readings,
      settings: const AppSettings(),
      period: ReportPeriod.days30,
      sections: ReportController.defaultSections,
      generatedAt: now,
    );

    expect(viewModel.hasData, isTrue);
    expect(viewModel.metrics, hasLength(6));
    expect(viewModel.ranges, hasLength(5));
    expect(viewModel.agpSlots, isNotEmpty);
    expect(viewModel.dailyCurves, hasLength(14));
    expect(viewModel.dataQuality.wearPercent, closeTo(100, 0.1));
    expect(viewModel.periodAnalysis.hasData, isTrue);
    expect(viewModel.episodesSummary.highestLabel, contains('mmol/L'));

    final percentTotal = viewModel.ranges.fold<double>(
      0,
      (sum, range) => sum + range.percent,
    );
    expect(percentTotal, closeTo(100, 0.01));
    expect(viewModel.header.targetRangeLabel, contains('mmol/L'));
    expect(viewModel.header.readingsLabel, contains('readings'));
  });

  test('deduplicates readings and calculates wear from active intervals', () {
    final now = DateTime(2026, 6, 5, 9);
    final readings = [
      GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 30)), value: 6.5),
      GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 25)), value: 6.6),
      GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 25)), value: 11.0),
      GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 5)), value: 11.2),
      GlucoseReading(timestamp: now, value: 6.7),
    ];

    final viewModel = const ReportService().buildViewModel(
      readings: readings,
      settings: const AppSettings(),
      period: ReportPeriod.days14,
      sections: ReportController.defaultSections,
      generatedAt: now,
    );

    expect(viewModel.header.readingsLabel, contains('4 readings'));
    expect(viewModel.dataQuality.duplicateCount, 1);
    expect(viewModel.dataQuality.gapCount, 1);
    expect(viewModel.dataQuality.activeMinutes, 15);
    expect(viewModel.dataQuality.wearPercent, closeTo(0.07, 0.01));
  });

  test('anchors daily curves to latest reading instead of generated time', () {
    final generatedAt = DateTime(2026, 6, 5, 9);
    final latestReadingDay = DateTime(2026, 5, 28);
    final readings = [
      for (var minute = 0; minute < 1440; minute += 5)
        GlucoseReading(
          timestamp: latestReadingDay.add(Duration(minutes: minute)),
          value: 6.8,
        ),
    ];

    final viewModel = const ReportService().buildViewModel(
      readings: readings,
      settings: const AppSettings(),
      period: ReportPeriod.days14,
      sections: ReportController.defaultSections,
      generatedAt: generatedAt,
    );

    expect(viewModel.dailyCurves.first.day, latestReadingDay);
    expect(viewModel.dailyCurves.first.sparse, isFalse);
  });
}

List<GlucoseReading> _readings(DateTime now, {required int days}) {
  final start =
      DateTime(now.year, now.month, now.day).subtract(Duration(days: days - 1));
  final readings = <GlucoseReading>[];
  for (var day = 0; day < days; day++) {
    final baseDay = start.add(Duration(days: day));
    for (var minute = 0; minute < 1440; minute += 5) {
      final hour = minute / 60;
      final dawn = hour >= 4 && hour <= 8 ? 1.4 : 0.0;
      final evening = hour >= 19 && hour <= 22 ? 0.8 : 0.0;
      final wave = 0.9 * math.sin(hour / 24 * math.pi * 2);
      final value = 6.7 + dawn + evening + wave;
      readings.add(
        GlucoseReading(
          timestamp: baseDay.add(Duration(minutes: minute)),
          value: value,
          ratePerMin: minute == 0 ? null : 0.01,
        ),
      );
    }
  }
  return readings;
}
