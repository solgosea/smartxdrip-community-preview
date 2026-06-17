import '../../../domain/low_episode_review_priority.dart';

class LowEpisodeBurdenRuleCatalog {
  const LowEpisodeBurdenRuleCatalog();

  LowEpisodeReviewPriority priority({
    required double nadirMmol,
    required int durationMinutes,
    required double areaBelowTarget,
    required bool recovered,
    required bool nocturnal,
    required bool repeated,
    required double lowThreshold,
  }) {
    if (nadirMmol < 3.0 ||
        durationMinutes >= 30 ||
        areaBelowTarget >= 45 ||
        !recovered ||
        (nocturnal && repeated)) {
      return LowEpisodeReviewPriority.important;
    }
    if (durationMinutes >= 10 ||
        nadirMmol < lowThreshold ||
        areaBelowTarget >= 8 ||
        nocturnal ||
        repeated) {
      return LowEpisodeReviewPriority.notable;
    }
    return LowEpisodeReviewPriority.info;
  }
}
