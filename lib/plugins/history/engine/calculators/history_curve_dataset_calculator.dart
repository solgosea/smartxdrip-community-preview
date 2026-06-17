import '../../../../domain/entities/glucose_event.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../../domain/history_curve_dataset.dart';

class HistoryCurveDatasetCalculator {
  const HistoryCurveDatasetCalculator();

  HistoryCurveDataset calculate({
    required DateTime selectedDay,
    required List<GlucoseReading> readings,
    required List<GlucoseEvent> events,
  }) {
    return HistoryCurveDataset(
      selectedDay: selectedDay,
      readings: readings,
      events: events,
    );
  }
}
