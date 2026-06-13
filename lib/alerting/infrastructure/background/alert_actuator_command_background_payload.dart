import '../../domain/actuator/alert_actuator_command.dart';

class AlertActuatorCommandBackgroundPayload {
  const AlertActuatorCommandBackgroundPayload();

  Map<String, Object?> encode(AlertActuatorCommand command) {
    return {
      'commandType': command.type.code,
      'eventId': command.target.eventId,
      'targetId': command.target.targetId,
      'type': command.target.type,
    };
  }
}
