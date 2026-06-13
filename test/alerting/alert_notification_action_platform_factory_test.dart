import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/domain/notification/alert_notification_action_category.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/alert_notification_action_ids.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/android_alert_notification_action_factory.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/ios_alert_notification_category_factory.dart';

void main() {
  test('Android notification actions use the shared alert action ids', () {
    final actions = const AndroidAlertNotificationActionFactory().actions();

    expect(actions.map((item) => item.id), [
      AlertNotificationActionIds.snooze,
      AlertNotificationActionIds.dismiss,
    ]);
    expect(actions.every((item) => item.cancelNotification), isTrue);
    expect(actions.every((item) => !item.showsUserInterface), isTrue);
  });

  test('iOS notification category exposes snooze and dismiss actions', () {
    final categories = const IosAlertNotificationCategoryFactory().categories();

    expect(categories, hasLength(1));
    expect(
      categories.single.identifier,
      AlertNotificationActionCategory.alertActions,
    );
    expect(categories.single.actions.map((item) => item.identifier), [
      AlertNotificationActionIds.snooze,
      AlertNotificationActionIds.dismiss,
    ]);
    expect(
      categories.single.actions.last.options,
      contains(DarwinNotificationActionOption.destructive),
    );
  });
}
