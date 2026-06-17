import 'dart:math';

import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../domain/report_data_quality.dart';
import '../../domain/report_range_band.dart';

class ReportCoverageCalculator {
  static const maxAttributedGapMinutes = 15;
  static const veryLowMmol = 3.0;

  const ReportCoverageCalculator();

  ReportDataQuality calculate(
    List<GlucoseReading> readings, {
    required AppSettings settings,
    required int periodDays,
    required int duplicateCount,
  }) {
    final expectedMinutes = max(0, periodDays) * 1440;
    if (readings.isEmpty || expectedMinutes == 0) {
      return ReportDataQuality.empty(
        expectedMinutes: expectedMinutes,
        duplicateCount: duplicateCount,
      );
    }

    final validDiffs = <int>[];
    for (var i = 1; i < readings.length; i++) {
      final minutes =
          readings[i].timestamp.difference(readings[i - 1].timestamp).inMinutes;
      if (minutes > 0 && minutes <= maxAttributedGapMinutes) {
        validDiffs.add(minutes);
      }
    }
    final fallbackInterval =
        validDiffs.isEmpty ? 5 : _medianInt(validDiffs).clamp(1, 15);

    final minutesByBand = <ReportRangeBand, int>{
      for (final band in ReportRangeBand.values) band: 0,
    };
    var activeMinutes = 0;
    var gaps = 0;
    for (var i = 0; i < readings.length; i++) {
      final current = readings[i];
      final rawMinutes = i == readings.length - 1
          ? fallbackInterval
          : readings[i + 1].timestamp.difference(current.timestamp).inMinutes;
      if (rawMinutes <= 0) continue;
      if (rawMinutes > maxAttributedGapMinutes) {
        gaps++;
        continue;
      }
      final minutes = rawMinutes.clamp(1, maxAttributedGapMinutes);
      activeMinutes += minutes;
      final band = bandFor(current.value, settings);
      minutesByBand[band] = minutesByBand[band]! + minutes;
    }

    return ReportDataQuality(
      minutesByBand: minutesByBand,
      activeMinutes: activeMinutes,
      expectedMinutes: expectedMinutes,
      duplicateCount: duplicateCount,
      gapCount: gaps,
    );
  }

  ReportRangeBand bandFor(double value, AppSettings settings) {
    if (value > settings.veryHighThreshold) return ReportRangeBand.veryHigh;
    if (value > settings.highThreshold) return ReportRangeBand.high;
    if (value >= settings.lowThreshold) return ReportRangeBand.inRange;
    if (value >= veryLowMmol) return ReportRangeBand.low;
    return ReportRangeBand.veryLow;
  }

  int _medianInt(List<int> values) {
    final sorted = [...values]..sort();
    return sorted[sorted.length ~/ 2];
  }
}
