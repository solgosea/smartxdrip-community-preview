import '../../domain/glance_snapshot.dart';

class GlanceRuntimeRefreshResult {
  final String reason;
  final bool force;
  final GlanceSnapshot snapshot;
  final DateTime completedAt;

  const GlanceRuntimeRefreshResult({
    required this.reason,
    required this.force,
    required this.snapshot,
    required this.completedAt,
  });
}
