class EpisodeRepeatTimeBlockBucket {
  final String label;
  final int count;
  final double normalizedHeight;
  final bool isDominant;
  final bool isSecondary;

  const EpisodeRepeatTimeBlockBucket({
    required this.label,
    required this.count,
    required this.normalizedHeight,
    required this.isDominant,
    required this.isSecondary,
  });
}
