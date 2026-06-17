import 'low_episode_driver_type.dart';

class LowEpisodeDriver {
  final LowEpisodeDriverType type;
  final double nadirScore;
  final double durationScore;
  final double areaScore;
  final double descentScore;
  final double recoveryScore;
  final double nocturnalScore;
  final double repeatScore;

  const LowEpisodeDriver({
    required this.type,
    required this.nadirScore,
    required this.durationScore,
    required this.areaScore,
    required this.descentScore,
    required this.recoveryScore,
    required this.nocturnalScore,
    required this.repeatScore,
  });
}
