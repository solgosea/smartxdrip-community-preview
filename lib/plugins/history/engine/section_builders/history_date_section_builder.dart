import '../../domain/sections/history_date_section.dart';

class HistoryDateSectionBuilder {
  const HistoryDateSectionBuilder();

  HistoryDateSection build({
    required DateTime selectedDay,
    required bool isToday,
  }) {
    return HistoryDateSection(selectedDay: selectedDay, isToday: isToday);
  }
}
