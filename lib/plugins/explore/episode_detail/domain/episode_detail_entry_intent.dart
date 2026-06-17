import '../models/episode_kind.dart';
import 'episode_detail_focus.dart';

enum EpisodeDetailEntryMode { latest, focused }

class EpisodeDetailEntryIntent {
  final EpisodeKind kind;
  final EpisodeDetailEntryMode mode;
  final EpisodeDetailFocus? focus;
  final DateTime? sourceDay;
  final String source;

  const EpisodeDetailEntryIntent({
    required this.kind,
    required this.mode,
    required this.focus,
    required this.sourceDay,
    required this.source,
  });

  const EpisodeDetailEntryIntent.latest({
    required EpisodeKind kind,
    String source = 'explore',
  }) : this(
          kind: kind,
          mode: EpisodeDetailEntryMode.latest,
          focus: null,
          sourceDay: null,
          source: source,
        );

  const EpisodeDetailEntryIntent.focused({
    required EpisodeKind kind,
    required EpisodeDetailFocus focus,
    DateTime? sourceDay,
    String source = 'history',
  }) : this(
          kind: kind,
          mode: EpisodeDetailEntryMode.focused,
          focus: focus,
          sourceDay: sourceDay,
          source: source,
        );

  bool get isFocused => mode == EpisodeDetailEntryMode.focused;
}
