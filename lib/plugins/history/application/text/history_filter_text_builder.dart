import 'package:intl/intl.dart';

import '../../domain/history_time_filter.dart';

class HistoryFilterTextBuilder {
  const HistoryFilterTextBuilder();

  String? label(HistoryTimeFilter? filter) {
    if (filter == null) return null;
    return 'Focused around ${DateFormat('HH:mm').format(filter.time)}';
  }
}
