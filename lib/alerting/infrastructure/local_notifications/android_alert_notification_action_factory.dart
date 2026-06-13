import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'alert_notification_action_ids.dart';

class AndroidAlertNotificationActionFactory {
  const AndroidAlertNotificationActionFactory();

  List<AndroidNotificationAction> actions() {
    return const [
      AndroidNotificationAction(
        AlertNotificationActionIds.snooze,
        'Snooze 5m',
        showsUserInterface: false,
        cancelNotification: true,
      ),
      AndroidNotificationAction(
        AlertNotificationActionIds.dismiss,
        'Dismiss',
        showsUserInterface: false,
        cancelNotification: true,
      ),
    ];
  }
}
