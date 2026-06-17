import '../../../domain/low_episode_repeat_pattern.dart';

class LowEpisodeRepeatRuleCatalog {
  const LowEpisodeRepeatRuleCatalog();

  LowEpisodeRepeatPatternType classify({
    required int nocturnalCount,
    required int afternoonCount,
    required int sameTimeCount,
    required int fastDescentCount,
  }) {
    if (sameTimeCount >= 2) return LowEpisodeRepeatPatternType.sameTime;
    if (nocturnalCount >= 2) return LowEpisodeRepeatPatternType.nocturnal;
    if (afternoonCount >= 2) return LowEpisodeRepeatPatternType.afternoon;
    if (fastDescentCount >= 2) return LowEpisodeRepeatPatternType.fastDescent;
    return LowEpisodeRepeatPatternType.none;
  }
}
