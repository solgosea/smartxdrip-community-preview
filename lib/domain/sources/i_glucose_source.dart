import '../entities/glucose_reading.dart';

/// Data source identifier — used to track which backend produced the reading.
enum DataSource { xdripHttp, nightscout }

/// Source interface for glucose readings. The repository chooses between
/// registered sources at runtime.
abstract class IGlucoseSource {
  DataSource get type;

  /// Latest single reading (most recent SGV).
  Future<GlucoseReading?> latest();

  /// Most recent N readings, newest last.
  Future<List<GlucoseReading>> recent({int count = 24});

  /// Readings in a time window [from, to].
  Future<List<GlucoseReading>> range({
    required DateTime from,
    required DateTime to,
  });

  /// Health check for source availability.
  Future<bool> isAvailable();
}
