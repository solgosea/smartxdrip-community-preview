class EpisodeRepeatDayMark {
  final DateTime date;
  final bool hasEpisode;
  final bool isCurrent;
  final bool isStrong;

  const EpisodeRepeatDayMark({
    required this.date,
    required this.hasEpisode,
    required this.isCurrent,
    required this.isStrong,
  });
}
