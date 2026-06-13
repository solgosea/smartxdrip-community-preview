class PollingBackoffState {
  final int consecutiveFailures;
  final DateTime? lastStartedAt;
  final DateTime? lastSuccessAt;
  final DateTime? lastFailureAt;
  final Object? lastError;

  const PollingBackoffState({
    this.consecutiveFailures = 0,
    this.lastStartedAt,
    this.lastSuccessAt,
    this.lastFailureAt,
    this.lastError,
  });

  const PollingBackoffState.initial()
      : consecutiveFailures = 0,
        lastStartedAt = null,
        lastSuccessAt = null,
        lastFailureAt = null,
        lastError = null;

  PollingBackoffState markStarted(DateTime at) {
    return PollingBackoffState(
      consecutiveFailures: consecutiveFailures,
      lastStartedAt: at,
      lastSuccessAt: lastSuccessAt,
      lastFailureAt: lastFailureAt,
      lastError: lastError,
    );
  }

  PollingBackoffState markSuccess(DateTime at) {
    return PollingBackoffState(
      consecutiveFailures: 0,
      lastStartedAt: lastStartedAt,
      lastSuccessAt: at,
      lastFailureAt: lastFailureAt,
      lastError: null,
    );
  }

  PollingBackoffState markFailure(DateTime at, Object error) {
    return PollingBackoffState(
      consecutiveFailures: consecutiveFailures + 1,
      lastStartedAt: lastStartedAt,
      lastSuccessAt: lastSuccessAt,
      lastFailureAt: at,
      lastError: error,
    );
  }
}
