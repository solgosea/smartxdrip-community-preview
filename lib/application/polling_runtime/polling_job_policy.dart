import 'dart:async';

import '../../domain/polling/polling_mode.dart';

typedef PollingRetryPredicate = FutureOr<bool> Function(Exception error);

class PollingJobPolicy {
  final bool runImmediatelyOnStart;
  final Duration foregroundInterval;
  final Duration backgroundInterval;
  final Duration failureBaseDelay;
  final Duration failureMaxDelay;
  final Duration retryDelayFactor;
  final Duration retryMaxDelay;
  final int retryMaxAttempts;
  final PollingRetryPredicate? retryIf;

  const PollingJobPolicy({
    this.runImmediatelyOnStart = true,
    this.foregroundInterval = const Duration(seconds: 30),
    this.backgroundInterval = const Duration(seconds: 60),
    this.failureBaseDelay = const Duration(seconds: 60),
    this.failureMaxDelay = const Duration(minutes: 5),
    this.retryDelayFactor = const Duration(milliseconds: 500),
    this.retryMaxDelay = const Duration(seconds: 5),
    this.retryMaxAttempts = 2,
    this.retryIf,
  });

  Duration intervalFor(PollingMode mode) {
    return switch (mode) {
      PollingMode.foreground => foregroundInterval,
      PollingMode.background => backgroundInterval,
    };
  }
}
