import '../../../domain/high_episode_recovery_quality.dart';

class HighEpisodeRecoveryRuleCatalog {
  const HighEpisodeRecoveryRuleCatalog();

  HighEpisodeRecoveryQuality quality(int? recoveryMinutes) {
    if (recoveryMinutes == null) return HighEpisodeRecoveryQuality.unknown;
    if (recoveryMinutes <= 60) return HighEpisodeRecoveryQuality.quick;
    if (recoveryMinutes <= 120) return HighEpisodeRecoveryQuality.moderate;
    return HighEpisodeRecoveryQuality.slow;
  }
}
