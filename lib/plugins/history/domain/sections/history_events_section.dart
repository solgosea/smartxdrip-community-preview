import '../history_event_context.dart';

class HistoryEventsSection {
  final List<HistoryEventContext> events;
  final bool focused;

  const HistoryEventsSection({
    required this.events,
    required this.focused,
  });
}
