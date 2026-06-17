import 'high_episode_driver_type.dart';

class HighEpisodeDriver {
  final HighEpisodeDriverType type;
  final double peakScore;
  final double durationScore;
  final double areaScore;
  final double riseScore;
  final double recoveryScore;
  final double repeatScore;

  const HighEpisodeDriver({
    required this.type,
    required this.peakScore,
    required this.durationScore,
    required this.areaScore,
    required this.riseScore,
    required this.recoveryScore,
    required this.repeatScore,
  });
}
