import '../sync_orchestration/glucose_source_sync_result.dart';

class UnifiedSyncRunResult {
  final String trigger;
  final Map<String, Object?> payload;
  final GlucoseSourceSyncResult sourceResult;
  final DateTime startedAt;
  final DateTime completedAt;

  const UnifiedSyncRunResult({
    required this.trigger,
    required this.payload,
    required this.sourceResult,
    required this.startedAt,
    required this.completedAt,
  });

  bool get success => sourceResult.success;

  int get fetchedCount => sourceResult.fetchedCount;

  int get storedCount => sourceResult.storedCount;

  Set<String> get updatedSubjectIds => sourceResult.updatedSubjectIds;
}
