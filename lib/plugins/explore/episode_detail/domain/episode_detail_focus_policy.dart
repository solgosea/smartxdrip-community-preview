class EpisodeDetailFocusPolicy {
  final Duration exactTolerance;
  final Duration nearestTolerance;

  const EpisodeDetailFocusPolicy({
    this.exactTolerance = const Duration(minutes: 2),
    this.nearestTolerance = const Duration(minutes: 15),
  });
}
