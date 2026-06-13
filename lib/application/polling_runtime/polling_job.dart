import 'polling_job_context.dart';
import 'polling_job_key.dart';
import 'polling_job_policy.dart';
import 'polling_job_result.dart';

abstract interface class PollingJob {
  PollingJobKey get key;

  PollingJobPolicy get policy;

  Future<PollingJobResult> run(PollingJobContext context);
}
