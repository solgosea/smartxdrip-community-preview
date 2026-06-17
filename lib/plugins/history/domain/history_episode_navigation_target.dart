import '../../explore/episode_detail/application/episode_detail_route_codec.dart';
import '../../explore/episode_detail/domain/episode_detail_entry_intent.dart';
import '../../explore/episode_detail/domain/episode_detail_focus.dart';
import '../../explore/episode_detail/models/episode_kind.dart';

class HistoryEpisodeNavigationTarget {
  final EpisodeKind kind;
  final DateTime eventTime;
  final DateTime? endTime;
  final double? value;
  final int? durationMinutes;
  final DateTime sourceDay;

  const HistoryEpisodeNavigationTarget({
    required this.kind,
    required this.eventTime,
    required this.endTime,
    required this.value,
    required this.durationMinutes,
    required this.sourceDay,
  });

  String route(
      {EpisodeDetailRouteCodec codec = const EpisodeDetailRouteCodec()}) {
    return codec.encode(
      EpisodeDetailEntryIntent.focused(
        kind: kind,
        focus: EpisodeDetailFocus(
          eventTime: eventTime,
          endTime: endTime,
          value: value,
          durationMinutes: durationMinutes,
        ),
        sourceDay: sourceDay,
        source: 'history',
      ),
    );
  }
}
