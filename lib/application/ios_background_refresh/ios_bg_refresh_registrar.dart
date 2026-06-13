import '../../infrastructure/ios_bg_task/ios_bg_task_channel.dart';
import '../../infrastructure/ios_bg_task/ios_bg_task_event.dart';
import 'ios_bg_refresh_config.dart';
import 'ios_bg_refresh_policy.dart';
import 'ios_bg_refresh_scheduler.dart';
import 'ios_bg_refresh_status.dart';
import 'ios_bg_refresh_status_store.dart';
import 'ios_bg_refresh_task_handler.dart';
import 'ios_bg_refresh_result.dart';

class IosBgRefreshRegistrar {
  final IosBgTaskChannel channel;
  final IosBgRefreshScheduler scheduler;
  final IosBgRefreshTaskHandler taskHandler;
  final IosBgRefreshStatusStore store;
  final IosBgRefreshConfig config;
  final IosBgRefreshPolicy policy;
  final Future<bool> Function() hasSyncTargets;
  final Future<IosBgRefreshResult> Function() runRefresh;

  bool _registered = false;

  IosBgRefreshRegistrar({
    required this.channel,
    required this.scheduler,
    required this.taskHandler,
    required this.store,
    required this.hasSyncTargets,
    required this.runRefresh,
    this.config = const IosBgRefreshConfig(),
    this.policy = const IosBgRefreshPolicy(),
  });

  Future<void> start() async {
    if (_registered) return;
    channel.onTaskStarted = _handleTaskStarted;
    final registered = await channel.registerRefreshTask(
      identifier: config.taskIdentifier,
    );
    _registered = registered;
    if (!registered) {
      store.update(
        const IosBgRefreshStatus.restricted(
          message: 'iOS background refresh registration failed.',
        ),
      );
      return;
    }
    if (await hasSyncTargets()) {
      await scheduler.scheduleNext();
    }
  }

  Future<void> scheduleIfNeeded() async {
    if (!_registered) return;
    if (!await hasSyncTargets()) return;
    await scheduler.scheduleNext();
  }

  Future<void> _handleTaskStarted(IosBgTaskEvent event) async {
    final status = await taskHandler.run(() async {
      final result = await runRefresh();
      if (!result.success) {
        throw StateError(result.message);
      }
    });
    await channel.completeRefreshTask(
      identifier: event.identifier,
      success: status.lastSuccessAt != null,
    );
    await scheduleIfNeeded();
  }
}
