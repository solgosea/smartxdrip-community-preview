import 'dart:math' as math;

import '../../../domain/low_episode_driver_type.dart';

class LowEpisodeDriverRuleCatalog {
  const LowEpisodeDriverRuleCatalog();

  LowEpisodeDriverType classify({
    required double nadirScore,
    required double durationScore,
    required double areaScore,
    required double descentScore,
    required double recoveryScore,
    required double nocturnalScore,
    required double repeatScore,
  }) {
    final scores = <LowEpisodeDriverType, double>{
      LowEpisodeDriverType.nadir: nadirScore,
      LowEpisodeDriverType.duration: math.max(durationScore, areaScore),
      LowEpisodeDriverType.fastDescent: descentScore,
      LowEpisodeDriverType.slowRecovery: recoveryScore,
      LowEpisodeDriverType.nocturnalTiming: nocturnalScore,
      LowEpisodeDriverType.repeatPattern: repeatScore,
    };
    final rows = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (rows.isEmpty || rows.first.value <= 0.05) {
      return LowEpisodeDriverType.mixed;
    }
    if (rows.length > 1 && (rows.first.value - rows[1].value).abs() < 0.12) {
      return LowEpisodeDriverType.mixed;
    }
    return rows.first.key;
  }
}
