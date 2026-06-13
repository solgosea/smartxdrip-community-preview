import 'sync_status_level.dart';
import 'sync_schedule_snapshot.dart';

class SyncStatusSnapshot {
  final String sourceLabel;
  final SyncStatusLevel level;
  final DateTime? lastSuccessAt;
  final DateTime? lastAttemptAt;
  final String? lastError;
  final int? lastFetchedCount;
  final int? lastStoredCount;
  final SyncScheduleSnapshot? schedule;
  final bool active;

  const SyncStatusSnapshot({
    required this.sourceLabel,
    required this.level,
    required this.active,
    this.lastSuccessAt,
    this.lastAttemptAt,
    this.lastError,
    this.lastFetchedCount,
    this.lastStoredCount,
    this.schedule,
  });
}
