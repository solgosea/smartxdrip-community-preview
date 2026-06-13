import '../../domain/polling/polling_mode.dart';
import 'polling_job_key.dart';

class PollingJobContext {
  final PollingJobKey key;
  final PollingMode mode;
  final DateTime now;
  final int consecutiveFailures;
  final DateTime? lastStartedAt;
  final DateTime? lastSuccessAt;
  final DateTime? lastFailureAt;

  const PollingJobContext({
    required this.key,
    required this.mode,
    required this.now,
    required this.consecutiveFailures,
    this.lastStartedAt,
    this.lastSuccessAt,
    this.lastFailureAt,
  });
}
