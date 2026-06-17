import '../../models/episode_kind.dart';

class EpisodeHeaderSection {
  final EpisodeKind kind;
  final String title;
  final DateTime? episodeTime;
  final String emptySubtitle;

  const EpisodeHeaderSection({
    required this.kind,
    required this.title,
    required this.episodeTime,
    required this.emptySubtitle,
  });
}
