class PollingJobResult {
  final bool success;
  final Duration? nextInterval;
  final Object? error;
  final String? message;

  const PollingJobResult({
    required this.success,
    this.nextInterval,
    this.error,
    this.message,
  });

  const PollingJobResult.success({
    this.nextInterval,
    this.message,
  })  : success = true,
        error = null;

  const PollingJobResult.failure({
    this.nextInterval,
    this.error,
    this.message,
  }) : success = false;
}
