import 'ios_bg_task_event.dart';

typedef IosBgTaskStartedHandler = Future<void> Function(IosBgTaskEvent event);

abstract class IosBgTaskChannel {
  IosBgTaskStartedHandler? onTaskStarted;

  Future<bool> registerRefreshTask({
    required String identifier,
  });

  Future<bool> scheduleRefreshTask({
    required String identifier,
    required DateTime earliestBeginDate,
  });

  Future<void> completeRefreshTask({
    required String identifier,
    required bool success,
  });
}
