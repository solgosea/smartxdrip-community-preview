import '../../../domain/episode_data_confidence.dart';

class LowEpisodeReliabilityRuleCatalog {
  const LowEpisodeReliabilityRuleCatalog();

  EpisodeDataConfidence confidence({
    required int largestGapMinutes,
    required bool hasNadirCoverage,
    required bool hasRecoveryCoverage,
  }) {
    if (largestGapMinutes <= 15 && hasNadirCoverage && hasRecoveryCoverage) {
      return EpisodeDataConfidence.high;
    }
    if (largestGapMinutes <= 30 && hasNadirCoverage) {
      return EpisodeDataConfidence.medium;
    }
    return EpisodeDataConfidence.low;
  }
}
