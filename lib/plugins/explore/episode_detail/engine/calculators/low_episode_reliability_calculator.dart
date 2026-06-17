import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

import '../../domain/low_episode_data_reliability.dart';
import '../rules/low_reliability/low_episode_reliability_rule_catalog.dart';

class LowEpisodeReliabilityCalculator {
  final LowEpisodeReliabilityRuleCatalog rules;

  const LowEpisodeReliabilityCalculator({
    this.rules = const LowEpisodeReliabilityRuleCatalog(),
  });

  LowEpisodeDataReliability calculate({
    required List<GlucoseReading> windowReadings,
    required DateTime nadirTime,
    required DateTime? recoveryTime,
  }) {
    final largestGap = _largestGap(windowReadings);
    final hasNadir = _hasCoverage(windowReadings, nadirTime);
    final hasRecovery = recoveryTime == null
        ? false
        : _hasCoverage(windowReadings, recoveryTime);
    final confidence = rules.confidence(
      largestGapMinutes: largestGap,
      hasNadirCoverage: hasNadir,
      hasRecoveryCoverage: hasRecovery,
    );
    return LowEpisodeDataReliability(
      readingsInWindow: windowReadings.length,
      largestGapMinutes: largestGap,
      hasNadirCoverage: hasNadir,
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
