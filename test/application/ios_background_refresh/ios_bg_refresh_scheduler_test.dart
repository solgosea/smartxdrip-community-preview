import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_config.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_scheduler.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status.dart';
import 'package:smart_xdrip/application/ios_background_refresh/ios_bg_refresh_status_store.dart';
import 'package:smart_xdrip/infrastructure/ios_bg_task/ios_bg_task_channel.dart';

void main() {
  test('channel scheduler schedules next iOS refresh request', () async {
    final channel = _FakeIosBgTaskChannel(scheduleResult: true);
    final store = IosBgRefreshStatusStore();
    addTearDown(store.dispose);

    final scheduler = ChannelIosBgRefreshScheduler(
      channel: channel,
      store: store,
      config: const IosBgRefreshConfig(
        minimumInterval: Duration(minutes: 20),
      ),
      now: () => DateTime(2026, 6, 10, 12),
    );

    final status = await scheduler.scheduleNext();

    expect(status.availability, IosBgRefreshAvailability.available);
    expect(channel.scheduledIdentifier, 'com.metaguru.smartxdrip.refresh');
    expect(
      channel.earliestBeginDate,
      DateTime(2026, 6, 10, 12, 20),
    );
  });
}

class _FakeIosBgTaskChannel implements IosBgTaskChannel {
  final bool scheduleResult;

  @override
  IosBgTaskStartedHandler? onTaskStarted;

  String? scheduledIdentifier;
  DateTime? earliestBeginDate;

  _FakeIosBgTaskChannel({required this.scheduleResult});

  @override
  Future<void> completeRefreshTask({
    required String identifier,
    required bool success,
  }) async {}

  @override
  Future<bool> registerRefreshTask({required String identifier}) async => true;

  @override
  Future<bool> scheduleRefreshTask({
    required String identifier,
    required DateTime earliestBeginDate,
  }) async {
    scheduledIdentifier = identifier;
    this.earliestBeginDate = earliestBeginDate;
    return scheduleResult;
  }
}
