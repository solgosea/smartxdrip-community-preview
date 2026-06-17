import '../models/episode_kind.dart';
import '../domain/episode_detail_focus.dart';
import 'episode_detail_runtime_snapshot.dart';

class EpisodeDetailRuntimeCache {
  final Map<String, EpisodeDetailRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;

  String? get staleReason => _staleReason;

  List<EpisodeDetailRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(EpisodeDetailRuntimeSnapshot snapshot) {
    _snapshots[_key(snapshot.subjectId, snapshot.kind, snapshot.focus)] =
        snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  EpisodeDetailRuntimeSnapshot? freshSnapshot({
    required String subjectId,
    required EpisodeKind kind,
    EpisodeDetailFocus? focus,
  }) {
    if (_stale) return null;
    return _snapshots[_key(subjectId, kind, focus)];
  }

  static String _key(
    String subjectId,
    EpisodeKind kind,
    EpisodeDetailFocus? focus,
  ) {
    final suffix = focus == null
        ? 'latest'
        : 'focused::${focus.eventTime.toIso8601String()}';
    return '$subjectId::${kind.name}::$suffix';
  }
}
