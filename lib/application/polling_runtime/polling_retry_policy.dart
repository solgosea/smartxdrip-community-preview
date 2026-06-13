import 'package:retry/retry.dart';

import 'polling_job_policy.dart';

class PollingRetryPolicy {
  const PollingRetryPolicy();

  Future<T> run<T>({
    required PollingJobPolicy policy,
    required Future<T> Function() action,
  }) {
    return RetryOptions(
      delayFactor: policy.retryDelayFactor,
      randomizationFactor: 0,
      maxDelay: policy.retryMaxDelay,
      maxAttempts: policy.retryMaxAttempts,
    ).retry(
      action,
      retryIf: (error) async {
        final predicate = policy.retryIf;
        return predicate == null ? true : predicate(error);
      },
    );
  }
}
