import 'dart:math' as math;

import '../../../domain/high_episode_driver_type.dart';

class HighEpisodeDriverRuleCatalog {
  const HighEpisodeDriverRuleCatalog();

  HighEpisodeDriverType classify({
    required double peakScore,
    required double durationScore,
    required double areaScore,
    required double riseScore,
    required double recoveryScore,
    required double repeatScore,
  }) {
    final scores = <HighEpisodeDriverType, double>{
      HighEpisodeDriverType.peak: peakScore,
      HighEpisodeDriverType.duration: math.max(durationScore, areaScore),
      HighEpisodeDriverType.fastRise: riseScore,
      HighEpisodeDriverType.slowRecovery: recoveryScore,
      HighEpisodeDriverType.repeatPattern: repeatScore,
    };
    final rows = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (rows.isEmpty || rows.first.value <= 0.05) {
      return HighEpisodeDriverType.mixed;
    }
    if (rows.length > 1 && (rows.first.value - rows[1].value).abs() < 0.12) {
      return HighEpisodeDriverType.mixed;
    }
    return rows.first.key;
  }
}
