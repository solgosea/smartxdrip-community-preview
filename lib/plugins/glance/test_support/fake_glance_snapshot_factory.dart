import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../application/glance_snapshot_builder.dart';
import '../domain/glance_snapshot.dart';

class FakeGlanceSnapshotFactory {
  const FakeGlanceSnapshotFactory();

  GlanceSnapshot inRange({DateTime? now}) {
    final currentNow = now ?? DateTime(2026, 6, 11, 12);
    final readings = [
      GlucoseReading(
        timestamp: currentNow.subtract(const Duration(minutes: 5)),
        value: 7.1,
        ratePerMin: .02,
      ),
      GlucoseReading(
        timestamp: currentNow.subtract(const Duration(minutes: 1)),
        value: 7.4,
        ratePerMin: .04,
      ),
    ];
    return const GlanceSnapshotBuilder().build(
      subjectId: 'self',
      settings: const AppSettings(),
      latest: readings.last,
      trendReadings: readings,
      tirReadings24h: readings,
      now: currentNow,
      sourceLabel: 'xDrip+ Local',
    );
  }
}
