import '../../../domain/entities/glucose_event.dart';
import 'history_time_filter.dart';

class HistoryTimeFilterPolicy {
  static const episodeTolerance = Duration(minutes: 30);
  static const eventTolerance = Duration(minutes: 45);

  const HistoryTimeFilterPolicy();

  bool includesEpisode(GlucoseEvent event, HistoryTimeFilter? filter) {
    if (filter == null) return true;
    if (event.type != GlucoseEventType.highEpisode &&
        event.type != GlucoseEventType.lowEpisode) {
      return false;
    }
    final selected = filter.time;
    final end = event.endTime;
    if (end != null &&
        !selected.isBefore(event.time) &&
        !selected.isAfter(end)) {
      return true;
    }
    if (_distance(selected, event.time) <= episodeTolerance) return true;
    if (end != null && _distance(selected, end) <= episodeTolerance) {
      return true;
    }
    return false;
  }

  bool includesEvent(GlucoseEvent event, HistoryTimeFilter? filter) {
    if (filter == null) return true;
    if (includesEpisode(event, filter)) return true;
    return _distance(filter.time, event.time) <= eventTolerance;
  }

  Duration _distance(DateTime a, DateTime b) {
    final diff = a.difference(b);
    return diff.isNegative ? -diff : diff;
  }
}
