import 'episode_repeat_chart_dataset.dart';

enum LowEpisodeRepeatPatternType {
  nocturnal,
  afternoon,
  sameTime,
  fastDescent,
  none,
}

class LowEpisodeRepeatIndicator {
  final String label;
  final bool active;

  const LowEpisodeRepeatIndicator({
    required this.label,
    required this.active,
  });
}

class LowEpisodeRepeatPattern {
  final LowEpisodeRepeatPatternType type;
  final int count;
  final int windowDays;
  final String? range;
  final List<LowEpisodeRepeatIndicator> indicators;
  final EpisodeRepeatChartDataset chartDataset;

  const LowEpisodeRepeatPattern({
    required this.type,
    required this.count,
    required this.windowDays,
    required this.range,
    required this.indicators,
    required this.chartDataset,
  });

  String get bigStat => '$count/$windowDays';
}
