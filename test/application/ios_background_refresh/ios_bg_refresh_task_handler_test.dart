import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status_store.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_task_handler.dart';

void main() {
  test('task handler records successful iOS background refresh attempt',
      () async {
    final times = [
      DateTime(2026, 6, 10, 12),
      DateTime(2026, 6, 10, 12, 0, 5),
    ];
    var index = 0;
    final store = IosBgRefreshStatusStore(
      initialStatus: const IosBgRefreshStatus.previewDisabled(),
    );
    addTearDown(store.dispose);

    final handler = IosBgRefreshTaskHandler(
      store: store,
      now: () => times[index++],
    );

    final status = await handler.run(() async {});

    expect(status.lastAttemptAt, times.first);
    expect(status.lastSuccessAt, times.last);
    expect(status.message, 'Background refresh completed.');
  });

  test('task handler records failed iOS background refresh attempt', () async {
    final times = [
      DateTime(2026, 6, 10, 12),
      DateTime(2026, 6, 10, 12, 0, 5),
    ];
    var index = 0;
    final store = IosBgRefreshStatusStore();
    addTearDown(store.dispose);

    final handler = IosBgRefreshTaskHandler(
      store: store,
      now: () => times[index++],
    );

    final status = await handler.run(() async {
      throw StateError('network unavailable');
    });

    expect(status.lastAttemptAt, times.last);
    expect(status.lastSuccessAt, isNull);
    expect(status.message, contains('network unavailable'));
  });
}
