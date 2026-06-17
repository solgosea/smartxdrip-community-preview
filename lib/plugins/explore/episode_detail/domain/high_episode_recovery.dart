import 'high_episode_recovery_quality.dart';

class HighEpisodeRecovery {
  final DateTime? recoveryTime;
  final int? recoveryMinutes;
  final bool recoveredInVisibleWindow;
  final HighEpisodeRecoveryQuality quality;

  const HighEpisodeRecovery({
    required this.recoveryTime,
    required this.recoveryMinutes,
    required this.recoveredInVisibleWindow,
    required this.quality,
  });
}
