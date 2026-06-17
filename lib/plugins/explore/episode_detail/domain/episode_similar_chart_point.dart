import 'episode_similar_match.dart';

class EpisodeSimilarChartPoint {
  final String id;
  final DateTime time;
  final double valueMmol;
  final int durationMinutes;
  final double score;
  final EpisodeSimilarMatchLabel label;
  final bool isCurrent;
  final bool isSelected;
  final bool slowOrUnknownRecovery;

  const EpisodeSimilarChartPoint({
    required this.id,
    required this.time,
    required this.valueMmol,
    required this.durationMinutes,
    required this.score,
    required this.label,
    required this.isCurrent,
    required this.isSelected,
    required this.slowOrUnknownRecovery,
  });
}
