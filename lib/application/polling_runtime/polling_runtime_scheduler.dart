import 'dart:async';

import '../../domain/polling/polling_mode.dart';
import 'polling_backoff_state_store.dart';
import 'polling_job.dart';
import 'polling_job_context.dart';
import 'polling_job_key.dart';
import 'polling_job_result.dart';
import 'polling_retry_policy.dart';

class PollingRuntimeScheduler {
  final PollingBackoffStateStore stateStore;
  final PollingRetryPolicy retryPolicy;
  final DateTime Function() clock;

  final Map<PollingJobKey, Timer> _timers = {};
  final Set<PollingJobKey> _enabledKeys = {};
  final Set<PollingJobKey> _runningKeys = {};

  PollingMode _mode = PollingMode.foreground;
  bool _active = false;

  PollingRuntimeScheduler({
    PollingBackoffStateStore? stateStore,
    this.retryPolicy = const PollingRetryPolicy(),
    DateTime Function()? clock,
  })  : stateStore = stateStore ?? PollingBackoffStateStore(),
        clock = clock ?? DateTime.now;

  bool get isActive => _active;

  PollingMode get mode => _mode;

  void start({
    required Iterable<PollingJob> jobs,
    required PollingMode mode,
  }) {
    _active = true;
    _mode = mode;
    for (final job in jobs) {
      schedule(
        job,
        delay: job.policy.runImmediatelyOnStart
            ? Duration.zero
            : job.policy.intervalFor(_mode),
      );
    }
  }

  void updateMode({
    required PollingMode mode,
    required Iterable<PollingJob> jobs,
  }) {
    _mode = mode;
    if (!_active) return;
    for (final job in jobs) {
      if (!_runningKeys.contains(job.key)) {
        schedule(job, delay: job.policy.intervalFor(_mode));
      }
    }
  }

  void schedule(PollingJob job, {Duration? delay}) {
    _enabledKeys.add(job.key);
    if (!_active) return;
    _timers.remove(job.key)?.cancel();
    _timers[job.key] = Timer(delay ?? job.policy.intervalFor(_mode), () {
      _timers.remove(job.key);
      unawaited(_run(job));
    });
  }

  void triggerNow(PollingJob job) {
    schedule(job, delay: Duration.zero);
  }

  void cancel(PollingJobKey key) {
    _enabledKeys.remove(key);
    _timers.remove(key)?.cancel();
    stateStore.remove(key);
  }

  void stop() {
    _active = false;
    for (final timer in _timers.values) {
      timer.cancel();
    }
    _timers.clear();
    _enabledKeys.clear();
  }

  Future<void> _run(PollingJob job) async {
    if (!_active || !_enabledKeys.contains(job.key)) return;
    if (_runningKeys.contains(job.key)) return;

    _runningKeys.add(job.key);
    final state = stateStore.markStarted(job.key, clock());
    final context = PollingJobContext(
      key: job.key,
      mode: _mode,
      now: clock(),
      consecutiveFailures: state.consecutiveFailures,
      lastStartedAt: state.lastStartedAt,
      lastSuccessAt: state.lastSuccessAt,
      lastFailureAt: state.lastFailureAt,
    );

    PollingJobResult result;
    try {
      result = await retryPolicy.run(
        policy: job.policy,
        action: () => job.run(context),
      );
    } catch (error) {
      result = PollingJobResult.failure(error: error);
    } finally {
      _runningKeys.remove(job.key);
    }

    if (!_active || !_enabledKeys.contains(job.key)) return;

    final nextDelay = _recordAndResolveNextDelay(job, result);
    schedule(job, delay: nextDelay);
  }

  Duration _recordAndResolveNextDelay(
    PollingJob job,
    PollingJobResult result,
  ) {
    if (result.success) {
      stateStore.markSuccess(job.key, clock());
      return result.nextInterval ?? job.policy.intervalFor(_mode);
    }

    stateStore.markFailure(
      job.key,
      clock(),
      result.error ?? result.message ?? 'polling job failed',
    );
    return result.nextInterval ??
        stateStore.failureDelay(key: job.key, policy: job.policy);
  }
}
