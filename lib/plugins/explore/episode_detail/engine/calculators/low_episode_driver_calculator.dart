import 'dart:math' as math;

import '../../domain/low_episode_burden.dart';
import '../../domain/low_episode_driver.dart';
import '../../domain/low_episode_recovery.dart';
import '../../domain/low_episode_repeat_pattern.dart';
import '../rules/low_driver/low_episode_driver_rule_catalog.dart';

class LowEpisodeDriverCalculator {
  final LowEpisodeDriverRuleCatalog rules;

  const LowEpisodeDriverCalculator({
    this.rules = const LowEpisodeDriverRuleCatalog(),
  });

  LowEpisodeDriver calculate({
    required LowEpisodeBurden burden,
    required LowEpisodeRecovery recovery,
    required LowEpisodeRepeatPattern repeat,
  }) {
    final nadirScore = (burden.nadirBelowThresholdMmol / 1.5).clamp(0.0, 1.0);
    final durationScore =
        (burden.durationMinutes / 60).toDouble().clamp(0.0, 1.0);
    final areaScore = (burden.areaBelowTarget / 60).clamp(0.0, 1.0);
    final descentScore = (burden.descentRateMmolPerMin / 0.12).clamp(0.0, 1.0);
    final recoveryScore =
        ((recovery.recoveryMinutes ?? 120) / 120).toDouble().clamp(0.0, 1.0);
    final nocturnalScore = burden.nocturnal ? 0.72 : 0.0;
    final repeatScore = math.min(repeat.count / 3, 1.0).toDouble();
    final type = rules.classify(
      nadirScore: nadirScore,
      durationScore: durationScore,
      areaScore: areaScore,
      descentScore: descentScore,
      recoveryScore: recovery.recoveredInVisibleWindow ? recoveryScore : 1.0,
      nocturnalScore: nocturnalScore,
      repeatScore: repeatScore,
    );
    return LowEpisodeDriver(
      type: type,
      nadirScore: nadirScore,
      durationScore: durationScore,
      areaScore: areaScore,
      descentScore: descentScore,
      recoveryScore: recoveryScore,
      nocturnalScore: nocturnalScore,
      repeatScore: repeatScore,
    );
  }
}
