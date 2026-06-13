enum IosBgRefreshAvailability {
  unsupported,
  notEnabled,
  available,
  restricted,
}

class IosBgRefreshStatus {
  final IosBgRefreshAvailability availability;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final String message;

  const IosBgRefreshStatus({
    required this.availability,
    this.lastAttemptAt,
    this.lastSuccessAt,
    required this.message,
  });

  const IosBgRefreshStatus.previewDisabled()
      : availability = IosBgRefreshAvailability.notEnabled,
        lastAttemptAt = null,
        lastSuccessAt = null,
        message =
            'iOS background refresh is not enabled in this preview build.';

  const IosBgRefreshStatus.available({
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.message =
        'iOS background refresh is scheduled when the system allows it.',
  }) : availability = IosBgRefreshAvailability.available;

  const IosBgRefreshStatus.restricted({
    this.lastAttemptAt,
    this.lastSuccessAt,
    required this.message,
  }) : availability = IosBgRefreshAvailability.restricted;

  IosBgRefreshStatus attempting(DateTime at) {
    return IosBgRefreshStatus(
      availability: availability,
      lastAttemptAt: at,
      lastSuccessAt: lastSuccessAt,
      message: 'Background refresh started.',
    );
  }

  IosBgRefreshStatus succeeded(DateTime at) {
    return IosBgRefreshStatus(
      availability: availability,
      lastAttemptAt: lastAttemptAt ?? at,
      lastSuccessAt: at,
      message: 'Background refresh completed.',
    );
  }

  IosBgRefreshStatus failed(DateTime at, String reason) {
    return IosBgRefreshStatus(
      availability: availability,
      lastAttemptAt: at,
      lastSuccessAt: lastSuccessAt,
      message: reason,
    );
  }
}
