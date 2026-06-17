import 'episode_data_confidence.dart';

class LowEpisodeDataReliability {
  final int readingsInWindow;
  final int largestGapMinutes;
  final bool hasNadirCoverage;
  final bool hasRecoveryCoverage;
  final EpisodeDataConfidence confidence;

  const LowEpisodeDataReliability({
    required this.readingsInWindow,
    required this.largestGapMinutes,
    required this.hasNadirCoverage,
    required this.hasRecoveryCoverage,
    required this.confidence,
  });
}
