import '../../../domain/entities/glucose_event.dart';
import '../../../domain/entities/glucose_reading.dart';

class HistoryCurveDataset {
  final DateTime selectedDay;
  final List<GlucoseReading> readings;
  final List<GlucoseEvent> events;

  const HistoryCurveDataset({
    required this.selectedDay,
    required this.readings,
    required this.events,
  });
}
