import '../../../../../domain/entities/glucose_event.dart';

class ReportEpisodesSection {
  final List<GlucoseEvent> highs;
  final List<GlucoseEvent> lows;
  final double? highest;
  final double? lowest;

  const ReportEpisodesSection({
    required this.highs,
    required this.lows,
    required this.highest,
    required this.lowest,
  });
}
