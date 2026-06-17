import '../../../../domain/entities/glucose_event.dart';
import '../../domain/history_episode_context.dart';
import '../../domain/history_time_filter.dart';
import '../../domain/sections/history_episode_section.dart';

class HistoryEpisodeSectionBuilder {
  const HistoryEpisodeSectionBuilder();

  HistoryEpisodeSection build({
    required List<GlucoseEvent> events,
    required HistoryTimeFilter? filter,
  }) {
    return HistoryEpisodeSection(
      episodes: [
        for (final event in events) HistoryEpisodeContext(event: event),
      ],
      focused: filter != null,
    );
  }
}
