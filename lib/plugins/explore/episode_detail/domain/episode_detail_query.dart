import '../models/episode_kind.dart';
import 'episode_detail_focus.dart';

class EpisodeDetailQuery {
  final String subjectId;
  final EpisodeKind kind;
  final DateTime anchorTime;
  final EpisodeDetailFocus? focus;
  final String source;

  const EpisodeDetailQuery({
    required this.subjectId,
    required this.kind,
    required this.anchorTime,
    this.focus,
    this.source = 'explore',
  });

  bool get isFocused => focus != null;
}
