abstract class AlertingCapability {
  Future<void> enqueueMessage(Map<String, Object?> payload);

  Future<void> snooze({
    required String scope,
    required Duration duration,
  });
}
