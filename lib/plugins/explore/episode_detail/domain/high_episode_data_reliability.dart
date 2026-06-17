import 'episode_data_confidence.dart';

class HighEpisodeDataReliability {
  final int readingsInWindow;
  final int largestGapMinutes;
  final bool hasPeakCoverage;
  final bool hasRecoveryCoverage;
  final EpisodeDataConfidence confidence;

  const HighEpisodeDataReliability({
    required this.readingsInWindow,
    required this.largestGapMinutes,
    required this.hasPeakCoverage,
    required this.hasRecoveryCoverage,
    required this.confidence,
  });
}
