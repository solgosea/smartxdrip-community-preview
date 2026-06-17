import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class EpisodeChartSection {
  final List<GlucoseReading> readings;
  final double lowThreshold;
  final double highThreshold;
  final DateTime onsetTime;
  final DateTime peakOrNadirTime;
  final DateTime episodeEndTime;
  final DateTime? recoveryTime;
  final DateTime timeRangeStart;
  final DateTime timeRangeEnd;

  const EpisodeChartSection({
    required this.readings,
    required this.lowThreshold,
    required this.highThreshold,
    required this.onsetTime,
    required this.peakOrNadirTime,
    required this.episodeEndTime,
    required this.recoveryTime,
    required this.timeRangeStart,
    required this.timeRangeEnd,
  });
}
