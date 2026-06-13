import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command.dart';
import 'package:smart_xdrip/alerting/domain/actuator/alert_actuator_command_type.dart';
import 'package:smart_xdrip/alerting/infrastructure/background/alert_actuator_command_background_payload.dart';

void main() {
  test('encodes stop commands for the Android background service bridge', () {
    final command = AlertActuatorCommand.stopTarget(
      id: 'cmd-1',
      targetId: 'child-1',
      type: 'urgentLow',
      createdAt: DateTime(2026, 6, 11, 10),
    );

    final payload =
        const AlertActuatorCommandBackgroundPayload().encode(command);

    expect(payload['commandType'], AlertActuatorCommandType.stopTarget.code);
    expect(payload['targetId'], 'child-1');
    expect(payload['type'], 'urgentLow');
    expect(payload['eventId'], isNull);
  });
}
