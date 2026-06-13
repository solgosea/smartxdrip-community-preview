import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/alert_notification_id.dart';

void main() {
  test('notification ids are stable and positive across calls', () {
    const ids = AlertNotificationId();

    final first = ids.fromAlertEventId('alert-urgent-low-1');
    final second = ids.fromAlertEventId('alert-urgent-low-1');
    final other = ids.fromAlertEventId('alert-high-1');

    expect(first, second);
    expect(first, isNonNegative);
    expect(first, isNot(other));
  });
}
