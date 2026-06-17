import 'dart:math';

import 'report_range_band.dart';

class ReportDataQuality {
  final Map<ReportRangeBand, int> minutesByBand;
  final int activeMinutes;
  final int expectedMinutes;
  final int duplicateCount;
  final int gapCount;

  const ReportDataQuality({
    required this.minutesByBand,
    required this.activeMinutes,
    required this.expectedMinutes,
    required this.duplicateCount,
    required this.gapCount,
  });

  factory ReportDataQuality.empty({
    required int expectedMinutes,
    required int duplicateCount,
  }) {
    return ReportDataQuality(
      minutesByBand: {
        for (final band in ReportRangeBand.values) band: 0,
      },
      activeMinutes: 0,
      expectedMinutes: expectedMinutes,
      duplicateCount: duplicateCount,
      gapCount: 0,
    );
  }

  double get wearPercent {
    if (expectedMinutes <= 0) return 0;
    return min(100, activeMinutes / expectedMinutes * 100);
  }

  int minutesFor(ReportRangeBand band) => minutesByBand[band] ?? 0;

  double percentFor(ReportRangeBand band) {
    if (activeMinutes <= 0) return 0;
    return minutesFor(band) / activeMinutes * 100;
  }
}
