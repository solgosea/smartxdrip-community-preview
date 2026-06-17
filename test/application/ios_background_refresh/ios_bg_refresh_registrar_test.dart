import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_config.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_registrar.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_result.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_scheduler.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status_store.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_task_handler.dart';
import 'package:smart_xdrip/infrastructure/ios_bg_task/ios_bg_task_channel.dart';
import 'package:smart_xdrip/infrastructure/ios_bg_task/ios_bg_task_event.dart';

void main() {
  test('registrar handles native task, runs refresh, completes and reschedules',
      () async {
    final channel = _FakeIosBgTaskChannel();
    final store = IosBgRefreshStatusStore(
      initialStatus: const IosBgRefreshStatus.available(),
    );
    addTearDown(store.dispose);
    final scheduler = ChannelIosBgRefreshScheduler(
      channel: channel,
      store: store,
      config: const IosBgRefreshConfig(
        minimumInterval: Duration(minutes: 15),
      ),
      now: () => DateTime(2026, 6, 10, 12),
    );
    var refreshRuns = 0;
    final registrar = IosBgRefreshRegistrar(
      channel: channel,
      scheduler: scheduler,
      taskHandler: IosBgRefreshTaskHandler(
        store: store,
        now: () => DateTime(2026, 6, 10, 12, refreshRuns++),
      ),
      store: store,
      hasSyncTargets: () async => true,
      runRefresh: () async => const IosBgRefreshResult.success(),
    );

    await registrar.start();
    await channel.onTaskStarted!(
      IosBgTaskEvent(
        identifier: 'com.metaguru.smartxdrip.refresh',
        startedAt: DateTime(2026, 6, 10, 12),
      ),
    );

    expect(channel.registeredIdentifier, 'com.metaguru.smartxdrip.refresh');
    expect(channel.completedSuccess, isTrue);
    expect(channel.scheduleCount, 2);
    expect(store.status.lastSuccessAt, isNotNull);
  });
}

class _FakeIosBgTaskChannel implements IosBgTaskChannel {
  @override
  IosBgTaskStartedHandler? onTaskStarted;

  String? registeredIdentifier;
  bool? completedSuccess;
  int scheduleCount = 0;

  @override
  Future<void> completeRefreshTask({
    required String identifier,
    required bool success,
  }) async {
    completedSuccess = success;
  }

  @override
  Future<bool> registerRefreshTask({required String identifier}) async {
    registeredIdentifier = identifier;
    return true;
  }

  @override
  Future<bool> scheduleRefreshTask({
    required String identifier,
    required DateTime earliestBeginDate,
  }) async {
    scheduleCount++;
    return true;
  }
}
