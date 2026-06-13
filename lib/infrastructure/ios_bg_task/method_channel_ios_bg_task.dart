import 'package:flutter/services.dart';

import 'ios_bg_task_channel.dart';
import 'ios_bg_task_error.dart';
import 'ios_bg_task_event_mapper.dart';

class MethodChannelIosBgTask implements IosBgTaskChannel {
  static const channelName = 'smart_xdrip/ios_bg_task';

  final MethodChannel channel;
  final IosBgTaskEventMapper eventMapper;

  @override
  IosBgTaskStartedHandler? onTaskStarted;

  MethodChannelIosBgTask({
    MethodChannel? channel,
    this.eventMapper = const IosBgTaskEventMapper(),
  }) : channel = channel ?? const MethodChannel(channelName) {
    this.channel.setMethodCallHandler(_handleCall);
  }

  @override
  Future<bool> registerRefreshTask({
    required String identifier,
  }) async {
    final result = await channel.invokeMethod<bool>(
      'registerRefreshTask',
      {'identifier': identifier},
    );
    return result ?? false;
  }

  @override
  Future<bool> scheduleRefreshTask({
    required String identifier,
    required DateTime earliestBeginDate,
  }) async {
    final result = await channel.invokeMethod<bool>(
      'scheduleRefreshTask',
      {
        'identifier': identifier,
        'earliestBeginDateMs': earliestBeginDate.millisecondsSinceEpoch,
      },
    );
    return result ?? false;
  }

  @override
  Future<void> completeRefreshTask({
    required String identifier,
    required bool success,
  }) async {
    await channel.invokeMethod<void>(
      'completeRefreshTask',
      {
        'identifier': identifier,
        'success': success,
      },
    );
  }

  Future<dynamic> _handleCall(MethodCall call) async {
    if (call.method != 'iosBgTaskStarted') {
      throw IosBgTaskError(
          'Unsupported iOS background task call: ${call.method}');
    }
    final handler = onTaskStarted;
    if (handler == null) return false;
    await handler(eventMapper.map(call.arguments));
    return true;
  }
}
