import 'episode_repeat_day_mark.dart';
import 'episode_repeat_time_block_bucket.dart';

class EpisodeRepeatChartDataset {
  final int windowDays;
  final int repeatCount;
  final String dominantBlockLabel;
  final String? dominantRangeLabel;
  final List<EpisodeRepeatDayMark> dayMarks;
  final List<EpisodeRepeatTimeBlockBucket> timeBlockBuckets;
  final String takeaway;

  const EpisodeRepeatChartDataset({
    required this.windowDays,
    required this.repeatCount,
    required this.dominantBlockLabel,
    required this.dominantRangeLabel,
    required this.dayMarks,
    required this.timeBlockBuckets,
    required this.takeaway,
  });
}
