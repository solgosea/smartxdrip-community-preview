import '../../../domain/high_episode_review_priority.dart';

class HighEpisodeBurdenRuleCatalog {
  const HighEpisodeBurdenRuleCatalog();

  HighEpisodeReviewPriority priority({
    required double peakMmol,
    required int durationMinutes,
    required double areaAboveTarget,
    required bool recovered,
    required bool repeated,
    required double highThreshold,
  }) {
    if (peakMmol >= 13.9 ||
        durationMinutes >= 120 ||
        areaAboveTarget >= 180 ||
        !recovered) {
      return HighEpisodeReviewPriority.important;
    }
    if (durationMinutes >= 30 ||
        peakMmol >= highThreshold + 1.0 ||
        areaAboveTarget >= 30 ||
        repeated) {
      return HighEpisodeReviewPriority.notable;
    }
    return HighEpisodeReviewPriority.info;
  }
}
