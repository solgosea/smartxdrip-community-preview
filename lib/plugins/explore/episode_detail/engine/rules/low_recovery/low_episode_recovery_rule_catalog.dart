import '../../../domain/low_episode_recovery_quality.dart';

class LowEpisodeRecoveryRuleCatalog {
  const LowEpisodeRecoveryRuleCatalog();

  LowEpisodeRecoveryQuality quality(int? recoveryMinutes) {
    if (recoveryMinutes == null) return LowEpisodeRecoveryQuality.unknown;
    if (recoveryMinutes <= 30) return LowEpisodeRecoveryQuality.quick;
    if (recoveryMinutes <= 90) return LowEpisodeRecoveryQuality.gradual;
    return LowEpisodeRecoveryQuality.slow;
  }
}
