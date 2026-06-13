import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../data/local/glucose_database.dart';
import '../background/background_alerting_runtime_factory.dart';

@pragma('vm:entry-point')
void alertNotificationBackgroundEntrypoint(NotificationResponse response) {
  unawaited(_handleAlertNotificationBackgroundResponse(response));
}

Future<void> _handleAlertNotificationBackgroundResponse(
  NotificationResponse response,
) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  final database = GlucoseDatabase();
  try {
    final factory = BackgroundAlertingRuntimeFactory(database: database);
    await factory.notificationActionDispatcher().dispatch(
          actionId: response.actionId ?? '',
          payload: response.payload,
        );
  } finally {
    await database.close();
  }
}
