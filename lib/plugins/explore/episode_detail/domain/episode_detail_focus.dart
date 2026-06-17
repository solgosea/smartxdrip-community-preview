class EpisodeDetailFocus {
  final DateTime eventTime;
  final DateTime? endTime;
  final double? value;
  final int? durationMinutes;

  const EpisodeDetailFocus({
    required this.eventTime,
    this.endTime,
    this.value,
    this.durationMinutes,
  });
}
