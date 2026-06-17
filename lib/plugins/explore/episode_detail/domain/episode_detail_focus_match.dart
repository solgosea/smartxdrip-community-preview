enum EpisodeDetailFocusMatchKind {
  latest,
  exactTime,
  nearTime,
  containsTime,
  notFound,
}

class EpisodeDetailFocusMatch {
  final EpisodeDetailFocusMatchKind kind;
  final Duration? offset;
  final bool explicit;

  const EpisodeDetailFocusMatch({
    required this.kind,
    required this.offset,
    required this.explicit,
  });

  const EpisodeDetailFocusMatch.latest()
      : this(
          kind: EpisodeDetailFocusMatchKind.latest,
          offset: null,
          explicit: false,
        );

  const EpisodeDetailFocusMatch.notFound()
      : this(
          kind: EpisodeDetailFocusMatchKind.notFound,
          offset: null,
          explicit: true,
        );

  bool get found => kind != EpisodeDetailFocusMatchKind.notFound;
}
