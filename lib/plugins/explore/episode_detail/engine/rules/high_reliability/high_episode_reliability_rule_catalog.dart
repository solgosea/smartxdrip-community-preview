import '../../../domain/episode_data_confidence.dart';

class HighEpisodeReliabilityRuleCatalog {
  const HighEpisodeReliabilityRuleCatalog();

  EpisodeDataConfidence confidence({
    required int largestGapMinutes,
    required bool hasPeakCoverage,
    required bool hasRecoveryCoverage,
  }) {
    if (largestGapMinutes <= 15 && hasPeakCoverage && hasRecoveryCoverage) {
      return EpisodeDataConfidence.high;
    }
    if (largestGapMinutes <= 30 && hasPeakCoverage) {
      return EpisodeDataConfidence.medium;
    }
    return EpisodeDataConfidence.low;
  }
}
