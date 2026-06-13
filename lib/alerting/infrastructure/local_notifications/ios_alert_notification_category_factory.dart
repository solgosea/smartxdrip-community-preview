import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/notification/alert_notification_action_category.dart';
import 'alert_notification_action_ids.dart';

class IosAlertNotificationCategoryFactory {
  const IosAlertNotificationCategoryFactory();

  List<DarwinNotificationCategory> categories() {
    return [
      DarwinNotificationCategory(
        AlertNotificationActionCategory.alertActions,
        actions: [
          DarwinNotificationAction.plain(
            AlertNotificationActionIds.snooze,
            'Snooze 5m',
          ),
          DarwinNotificationAction.plain(
            AlertNotificationActionIds.dismiss,
            'Dismiss',
            options: {
              DarwinNotificationActionOption.destructive,
            },
          ),
        ],
      ),
    ];
  }
}
