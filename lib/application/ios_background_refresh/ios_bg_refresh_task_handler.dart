import 'ios_bg_refresh_status.dart';
import 'ios_bg_refresh_status_store.dart';

typedef IosBgRefreshTask = Future<void> Function();

class IosBgRefreshTaskHandler {
  final IosBgRefreshStatusStore store;
  final DateTime Function() now;

  const IosBgRefreshTaskHandler({
    required this.store,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<IosBgRefreshStatus> run(IosBgRefreshTask task) async {
    final startedAt = now();
    store.update(store.status.attempting(startedAt));
    try {
      await task();
      final status = store.status.succeeded(now());
      store.update(status);
      return status;
    } catch (error) {
      final status = store.status.failed(
        now(),
        'Background refresh failed: $error',
      );
      store.update(status);
      return status;
    }
  }
}
