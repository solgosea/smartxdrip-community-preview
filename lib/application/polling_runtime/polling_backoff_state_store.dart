import '../polling/polling_backoff_calculator.dart';
import 'polling_backoff_state.dart';
import 'polling_job_key.dart';
import 'polling_job_policy.dart';

class PollingBackoffStateStore {
  final PollingBackoffCalculator calculator;
  final Map<PollingJobKey, PollingBackoffState> _states = {};

  PollingBackoffStateStore({
    this.calculator = const PollingBackoffCalculator(),
  });

  PollingBackoffState stateFor(PollingJobKey key) {
    return _states[key] ?? const PollingBackoffState.initial();
  }

  PollingBackoffState markStarted(PollingJobKey key, DateTime at) {
    final state = stateFor(key).markStarted(at);
    _states[key] = state;
    return state;
  }

  PollingBackoffState markSuccess(PollingJobKey key, DateTime at) {
    final state = stateFor(key).markSuccess(at);
    _states[key] = state;
    return state;
  }

  PollingBackoffState markFailure(
    PollingJobKey key,
    DateTime at,
    Object error,
  ) {
    final state = stateFor(key).markFailure(at, error);
    _states[key] = state;
    return state;
  }

  Duration failureDelay({
    required PollingJobKey key,
    required PollingJobPolicy policy,
  }) {
    return PollingBackoffCalculator(baseDelay: policy.failureBaseDelay).delay(
      consecutiveFailures: stateFor(key).consecutiveFailures,
      maxDelay: policy.failureMaxDelay,
    );
  }

  void remove(PollingJobKey key) {
    _states.remove(key);
  }

  void clear() {
    _states.clear();
  }
}
