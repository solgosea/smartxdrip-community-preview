import '../history_episode_context.dart';

class HistoryEpisodeSection {
  final List<HistoryEpisodeContext> episodes;
  final bool focused;

  const HistoryEpisodeSection({
    required this.episodes,
    required this.focused,
  });
}
