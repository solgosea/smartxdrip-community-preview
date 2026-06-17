import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../domain/episode_detail_focus.dart';

class EpisodeDetailRuntimeSnapshot {
  final String subjectId;
  final EpisodeKind kind;
  final EpisodeDetailFocus? focus;
  final EpisodeDetailViewModel viewModel;
  final DateTime updatedAt;
  final String reason;

  const EpisodeDetailRuntimeSnapshot({
    required this.subjectId,
    required this.kind,
    this.focus,
    required this.viewModel,
    required this.updatedAt,
    required this.reason,
  });
}
