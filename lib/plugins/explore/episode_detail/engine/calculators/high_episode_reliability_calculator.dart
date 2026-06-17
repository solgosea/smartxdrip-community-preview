import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/high_episode_data_reliability.dart';
import '../rules/high_reliability/high_episode_reliability_rule_catalog.dart';

class HighEpisodeReliabilityCalculator {
  final HighEpisodeReliabilityRuleCatalog rules;

  const HighEpisodeReliabilityCalculator({
    this.rules = const HighEpisodeReliabilityRuleCatalog(),
  });

  HighEpisodeDataReliability calculate({
    required List<GlucoseReading> windowReadings,
    required DateTime peakTime,
    required DateTime? recoveryTime,
  }) {
    final largestGap = _largestGap(windowReadings);
    final hasPeak = _hasCoverage(windowReadings, peakTime);
    final hasRecovery = recoveryTime == null
        ? false
        : _hasCoverage(windowReadings, recoveryTime);
    final confidence = rules.confidence(
      largestGapMinutes: largestGap,
      hasPeakCoverage: hasPeak,
      hasRecoveryCoverage: hasRecovery,
    );
    return HighEpisodeDataReliability(
      readingsInWindow: windowReadings.length,
      largestGapMinutes: largestGap,
      hasPeakCoverage: hasPeak,
      hasRecoveryCoverage: hasRecovery,
      confidence: confidence,
    );
  }

  int _largestGap(List<GlucoseReading> readings) {
    if (readings.length < 2) return readings.isEmpty ? 999 : 0;
    final rows = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    var largest = 0;
    for (var i = 1; i < rows.length; i++) {
      largest = math.max(
        largest,
        rows[i].timestamp.difference(rows[i - 1].timestamp).inMinutes,
      );
    }
    return largest;
  }

  bool _hasCoverage(List<GlucoseReading> readings, DateTime time) {
    return readings.any(
      (reading) => reading.timestamp.difference(time).inMinutes.abs() <= 10,
    );
  }
}
