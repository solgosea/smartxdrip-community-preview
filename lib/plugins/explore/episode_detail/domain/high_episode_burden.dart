import 'high_episode_review_priority.dart';

class HighEpisodeBurden {
  final HighEpisodeReviewPriority priority;
  final double peakMmol;
  final int durationMinutes;
  final double areaAboveTarget;
  final double riseRateMmolPerMin;
  final int? recoveryMinutes;
  final double peakOverThresholdMmol;

  const HighEpisodeBurden({
    required this.priority,
    required this.peakMmol,
    required this.durationMinutes,
    required this.areaAboveTarget,
    required this.riseRateMmolPerMin,
    required this.recoveryMinutes,
    required this.peakOverThresholdMmol,
  });
}
