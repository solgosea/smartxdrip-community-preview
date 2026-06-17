import '../../../domain/high_episode_repeat_pattern.dart';

class HighEpisodeRepeatRuleCatalog {
  const HighEpisodeRepeatRuleCatalog();

  HighEpisodeRepeatPatternType classify({
    required int morningCount,
    required int eveningCount,
    required int sameTimeCount,
  }) {
    if (sameTimeCount >= 3) return HighEpisodeRepeatPatternType.sameTime;
    if (morningCount >= 2 && morningCount >= eveningCount) {
      return HighEpisodeRepeatPatternType.morning;
    }
    if (eveningCount >= 2) return HighEpisodeRepeatPatternType.evening;
    return HighEpisodeRepeatPatternType.none;
  }
}
