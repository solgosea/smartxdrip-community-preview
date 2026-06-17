import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/low_episode_baseline_context.dart';
import 'episode_window_calculator.dart';

class LowEpisodeBaselineCalculator {
  const LowEpisodeBaselineCalculator();

  LowEpisodeBaselineContext calculate({
    required DateTime episodeTime,
    required EpisodeWindowAnalysis window,
    required List<GlucoseReading> allReadings,
  }) {
    final nadirs = _dailyNadirs(allReadings, episodeTime, 30)..sort();
    final variability = _variabilityForHour(allReadings, episodeTime.hour);
    return LowEpisodeBaselineContext(
      baselineLowMmol: window.baselineLow,
      baselineHighMmol: window.baselineHigh,
      usualNadirLowMmol: _percentile(nadirs, 25),
      usualNadirHighMmol: _percentile(nadirs, 75),
      variabilityLabel: variability?.label,
      variabilityWindowText: variability?.windowText,
      variabilityCv: variability?.cv,
      variabilityRank: variability?.rank,
      variabilityTotal: variability?.total,
      leadUpSlope: window.leadUpSlope,
      typicalSlope: _typicalSlopeForHours(
        allReadings,
        startHour: episodeTime.hour >= 0 && episodeTime.hour < 6 ? 0 : 6,
        endHour: episodeTime.hour >= 0 && episodeTime.hour < 6 ? 6 : 24,
      ),
    );
  }

  List<double> _dailyNadirs(
    List<GlucoseReading> readings,
    DateTime anchor,
    int days,
  ) {
    final cutoff = anchor.subtract(Duration(days: days));
    final byDay = <DateTime, List<GlucoseReading>>{};
    for (final reading in readings) {
      if (reading.timestamp.isBefore(cutoff) ||
          reading.timestamp.isAfter(anchor)) {
        continue;
      }
      final key = DateTime(
        reading.timestamp.year,
        reading.timestamp.month,
        reading.timestamp.day,
      );
      byDay.putIfAbsent(key, () => []).add(reading);
    }
    return [
      for (final rows in byDay.values)
        rows.map((row) => row.value).reduce(math.min),
    ];
  }

  double? _percentile(List<double> sorted, int percentile) {
    if (sorted.length < 5) return null;
    final index = ((percentile / 100) * (sorted.length - 1)).round();
    return sorted[index.clamp(0, sorted.length - 1).toInt()];
  }

  double? _typicalSlopeForHours(
    List<GlucoseReading> readings, {
    required int startHour,
    required int endHour,
  }) {
    final slopes = <double>[];
    final sorted = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (var i = 1; i < sorted.length; i++) {
      final previous = sorted[i - 1];
      final current = sorted[i];
      if (!_isInsideHourWindow(previous.timestamp.hour, startHour, endHour) ||
          !_isInsideHourWindow(current.timestamp.hour, startHour, endHour)) {
        continue;
      }
      final minutes =
          current.timestamp.difference(previous.timestamp).inMinutes;
      if (minutes <= 0 || minutes > 30) continue;
      slopes.add((current.value - previous.value) / minutes);
    }
    if (slopes.isEmpty) return null;
    return slopes.reduce((a, b) => a + b) / slopes.length;
  }

  _PeriodVariability? _variabilityForHour(
    List<GlucoseReading> readings,
    int hour,
  ) {
    final periods = <_PeriodBucket>[
      const _PeriodBucket('Overnight', '00:00-06:00', 0, 6),
      const _PeriodBucket('Morning', '06:00-12:00', 6, 12),
      const _PeriodBucket('Afternoon', '12:00-18:00', 12, 18),
      const _PeriodBucket('Evening', '18:00-24:00', 18, 24),
    ];
    final ranked = <_PeriodVariability>[];
    for (final bucket in periods) {
      final rows = readings
          .where((r) =>
              _isInsideHourWindow(r.timestamp.hour, bucket.start, bucket.end))
          .toList();
      final cv = _cv(rows);
      if (cv == null) continue;
      ranked.add(_PeriodVariability(
        label: bucket.label,
        windowText: bucket.windowText,
        cv: cv,
        rank: 0,
        total: 0,
      ));
    }
    if (ranked.isEmpty) return null;
    ranked.sort((a, b) => b.cv.compareTo(a.cv));
    final target = periods.firstWhere(
      (p) => _isInsideHourWindow(hour, p.start, p.end),
      orElse: () => periods.first,
    );
    for (var i = 0; i < ranked.length; i++) {
      final item = ranked[i];
      if (item.label == target.label) {
        return _PeriodVariability(
          label: item.label,
          windowText: item.windowText,
          cv: item.cv,
          rank: i + 1,
          total: ranked.length,
        );
      }
    }
    return null;
  }

  bool _isInsideHourWindow(int hour, int start, int end) {
    if (end == 24) return hour >= start && hour < 24;
    return hour >= start && hour < end;
  }

  double? _cv(List<GlucoseReading> rows) {
    if (rows.length < 2) return null;
    final mean = rows.map((r) => r.value).reduce((a, b) => a + b) / rows.length;
    if (mean == 0) return null;
    final variance =
        rows.map((r) => math.pow(r.value - mean, 2)).reduce((a, b) => a + b) /
            rows.length;
    return math.sqrt(variance) / mean * 100;
  }
}

class _PeriodBucket {
  final String label;
  final String windowText;
  final int start;
  final int end;

  const _PeriodBucket(this.label, this.windowText, this.start, this.end);
}

class _PeriodVariability {
  final String label;
  final String windowText;
  final double cv;
  final int rank;
  final int total;

  const _PeriodVariability({
    required this.label,
    required this.windowText,
    required this.cv,
    required this.rank,
    required this.total,
  });
}
