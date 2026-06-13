import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/actuator/notification_alert_actuator.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command_type.dart';
import 'package:smart_xdrip/alerting/infrastructure/local_notifications/flutter_local_notification_gateway.dart';

void main() {
  test('notification actuator cancels system notifications for target stop',
      () async {
    final gateway = _RecordingNotificationGateway();
    final actuator = NotificationAlertActuator(gateway: gateway);
    final command = AlertActuatorCommand.stopTarget(
      id: 'cmd-1',
      targetId: 'child-1',
      type: 'urgentLow',
      createdAt: DateTime(2026, 6, 11, 10),
    );

    expect(actuator.supports(command), isTrue);

    final result = await actuator.execute(command);

    expect(result.success, isTrue);
    expect(gateway.cancelAllCount, 1);
  });

  test('notification actuator still supports exact event cancellation',
      () async {
    final gateway = _RecordingNotificationGateway();
    final actuator = NotificationAlertActuator(gateway: gateway);
    final command = AlertActuatorCommand.stopEvent(
      id: 'cmd-1',
      eventId: 'alert-1',
      createdAt: DateTime(2026, 6, 11, 10),
    );

    expect(command.type, AlertActuatorCommandType.stopEvent);

    final result = await actuator.execute(command);

    expect(result.success, isTrue);
    expect(gateway.cancelledEventIds, ['alert-1']);
  });
}

class _RecordingNotificationGateway extends FlutterLocalNotificationGateway {
  final List<String> cancelledEventIds = [];
  int cancelAllCount = 0;

  @override
  Future<void> cancel(String alertEventId) async {
    cancelledEventIds.add(alertEventId);
  }

  @override
  Future<void> cancelAll() async {
    cancelAllCount += 1;
  }
}
