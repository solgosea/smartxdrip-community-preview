import 'dart:math' as math;

import '../../domain/high_episode_burden.dart';
import '../../domain/high_episode_driver.dart';
import '../../domain/high_episode_recovery.dart';
import '../../domain/high_episode_repeat_pattern.dart';
import '../rules/high_driver/high_episode_driver_rule_catalog.dart';

class HighEpisodeDriverCalculator {
  final HighEpisodeDriverRuleCatalog rules;

  const HighEpisodeDriverCalculator({
    this.rules = const HighEpisodeDriverRuleCatalog(),
  });

  HighEpisodeDriver calculate({
    required HighEpisodeBurden burden,
    required HighEpisodeRecovery recovery,
    required HighEpisodeRepeatPattern repeat,
  }) {
    final peakScore = (burden.peakOverThresholdMmol / 3.9).clamp(0.0, 1.0);
    final durationScore =
        (burden.durationMinutes / 120).toDouble().clamp(0.0, 1.0);
    final areaScore = (burden.areaAboveTarget / 180).clamp(0.0, 1.0);
    final riseScore = (burden.riseRateMmolPerMin / 0.12).clamp(0.0, 1.0);
    final recoveryScore =
        ((recovery.recoveryMinutes ?? 180) / 180).toDouble().clamp(0.0, 1.0);
    final repeatScore = math.min(repeat.count / 3, 1.0).toDouble();
    final type = rules.classify(
      peakScore: peakScore,
      durationScore: durationScore,
      areaScore: areaScore,
      riseScore: riseScore,
      recoveryScore: recovery.recoveredInVisibleWindow ? recoveryScore : 1.0,
      repeatScore: repeatScore,
    );
    return HighEpisodeDriver(
      type: type,
      peakScore: peakScore,
      durationScore: durationScore,
      areaScore: areaScore,
      riseScore: riseScore,
      recoveryScore: recoveryScore,
      repeatScore: repeatScore,
    );
  }
}
