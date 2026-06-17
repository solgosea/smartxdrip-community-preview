import '../../../../domain/entities/glucose_event.dart';
import '../../domain/history_event_context.dart';
import '../../domain/history_time_filter.dart';
import '../../domain/sections/history_events_section.dart';

class HistoryEventsSectionBuilder {
  const HistoryEventsSectionBuilder();

  HistoryEventsSection build({
    required List<GlucoseEvent> events,
    required HistoryTimeFilter? filter,
  }) {
    return HistoryEventsSection(
      events: [
        for (final event in events) HistoryEventContext(event: event),
      ],
      focused: filter != null,
    );
  }
}
