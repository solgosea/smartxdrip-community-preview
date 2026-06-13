import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../application/action/alert_notification_action_dispatcher.dart';

class AlertNotificationActionRouter {
  final AlertNotificationActionDispatcher dispatcher;

  const AlertNotificationActionRouter({
    required this.dispatcher,
  });

  Future<void> handle(NotificationResponse response) async {
    final actionId = response.actionId;
    if (actionId == null || actionId.isEmpty) return;
    await dispatcher.dispatch(
      actionId: actionId,
      payload: response.payload,
    );
  }
}
