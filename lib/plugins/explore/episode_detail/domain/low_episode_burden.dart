import 'low_episode_review_priority.dart';

class LowEpisodeBurden {
  final LowEpisodeReviewPriority priority;
  final double nadirMmol;
  final int durationMinutes;
  final double areaBelowTarget;
  final double descentRateMmolPerMin;
  final int? recoveryMinutes;
  final double nadirBelowThresholdMmol;
  final bool nocturnal;

  const LowEpisodeBurden({
    required this.priority,
    required this.nadirMmol,
    required this.durationMinutes,
    required this.areaBelowTarget,
    required this.descentRateMmolPerMin,
    required this.recoveryMinutes,
    required this.nadirBelowThresholdMmol,
    required this.nocturnal,
  });
}
