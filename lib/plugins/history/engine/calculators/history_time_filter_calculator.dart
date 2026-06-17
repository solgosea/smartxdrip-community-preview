import '../../domain/history_time_filter.dart';

class HistoryTimeFilterCalculator {
  const HistoryTimeFilterCalculator();

  HistoryTimeFilter? fromTime(DateTime? time) {
    if (time == null) return null;
    return HistoryTimeFilter(time: time);
  }
}
