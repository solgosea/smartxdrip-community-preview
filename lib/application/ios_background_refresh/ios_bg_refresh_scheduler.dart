import 'ios_bg_refresh_status.dart';
import 'ios_bg_refresh_status_store.dart';
import 'ios_bg_refresh_config.dart';
import '../../infrastructure/ios_bg_task/ios_bg_task_channel.dart';

abstract class IosBgRefreshScheduler {
  Future<IosBgRefreshStatus> scheduleNext();
}

class PreviewIosBgRefreshScheduler implements IosBgRefreshScheduler {
  final IosBgRefreshStatusStore store;

  const PreviewIosBgRefreshScheduler({
    required this.store,
  });

  @override
  Future<IosBgRefreshStatus> scheduleNext() async {
    const status = IosBgRefreshStatus.previewDisabled();
    store.update(status);
    return status;
  }
}

class ChannelIosBgRefreshScheduler implements IosBgRefreshScheduler {
  final IosBgTaskChannel channel;
  final IosBgRefreshStatusStore store;
  final IosBgRefreshConfig config;
  final DateTime Function() now;

  const ChannelIosBgRefreshScheduler({
    required this.channel,
    required this.store,
    this.config = const IosBgRefreshConfig(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  @override
  Future<IosBgRefreshStatus> scheduleNext() async {
    final earliest = config.nextEarliestBeginDate(now());
    final scheduled = await channel.scheduleRefreshTask(
      identifier: config.taskIdentifier,
      earliestBeginDate: earliest,
    );
    final current = store.status;
    final status = scheduled
        ? IosBgRefreshStatus.available(
            lastAttemptAt: current.lastAttemptAt,
            lastSuccessAt: current.lastSuccessAt,
          )
        : IosBgRefreshStatus.restricted(
            lastAttemptAt: current.lastAttemptAt,
            lastSuccessAt: current.lastSuccessAt,
            message: 'iOS background refresh could not be scheduled.',
          );
    store.update(status);
    return status;
  }
}
