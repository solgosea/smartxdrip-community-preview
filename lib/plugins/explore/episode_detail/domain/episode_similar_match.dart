import 'package:smart_xdrip/domain/entities/glucose_event.dart';

enum EpisodeSimilarMatchLabel {
  verySimilar,
  similar,
  looseMatch,
}

class EpisodeSimilarMatch {
  final GlucoseEvent event;
  final double score;
  final EpisodeSimilarMatchLabel label;
  final double valueMmol;
  final int durationMinutes;
  final bool recoveryVisible;
  final bool slowOrUnknownRecovery;

  const EpisodeSimilarMatch({
    required this.event,
    required this.score,
    required this.label,
    required this.valueMmol,
    required this.durationMinutes,
    required this.recoveryVisible,
    required this.slowOrUnknownRecovery,
  });
}
