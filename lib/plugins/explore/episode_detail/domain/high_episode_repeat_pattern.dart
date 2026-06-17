import 'episode_repeat_chart_dataset.dart';

enum HighEpisodeRepeatPatternType { morning, evening, sameTime, none }

class HighEpisodeRepeatIndicator {
  final String label;
  final bool active;

  const HighEpisodeRepeatIndicator({
    required this.label,
    required this.active,
  });
}

class HighEpisodeRepeatPattern {
  final HighEpisodeRepeatPatternType type;
  final int count;
  final int windowDays;
  final String? range;
  final List<HighEpisodeRepeatIndicator> indicators;
  final EpisodeRepeatChartDataset chartDataset;

  const HighEpisodeRepeatPattern({
    required this.type,
    required this.count,
    required this.windowDays,
    required this.range,
    required this.indicators,
    required this.chartDataset,
  });

  String get bigStat => '$count/$windowDays';
}
