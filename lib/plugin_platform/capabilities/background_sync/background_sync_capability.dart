abstract class BackgroundSyncCapability {
  bool get running;

  Future<void> ensureRunning({required String reason});

  Future<void> reconcile({required String reason});
}
