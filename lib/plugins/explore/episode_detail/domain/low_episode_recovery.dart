import 'low_episode_recovery_quality.dart';

class LowEpisodeRecovery {
  final DateTime? recoveryTime;
  final int? recoveryMinutes;
  final bool recoveredInVisibleWindow;
  final LowEpisodeRecoveryQuality quality;

  const LowEpisodeRecovery({
    required this.recoveryTime,
    required this.recoveryMinutes,
    required this.recoveredInVisibleWindow,
    required this.quality,
  });
}
