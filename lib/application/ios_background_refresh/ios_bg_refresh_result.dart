class IosBgRefreshResult {
  final bool success;
  final String message;

  const IosBgRefreshResult({
    required this.success,
    required this.message,
  });

  const IosBgRefreshResult.success([
    this.message = 'Background refresh completed.',
  ]) : success = true;

  const IosBgRefreshResult.failure(this.message) : success = false;
}
