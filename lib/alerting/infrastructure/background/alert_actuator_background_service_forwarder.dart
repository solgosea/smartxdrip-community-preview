import 'dart:io';

import 'package:flutter_background_service/flutter_background_service.dart';

import '../../../infrastructure/background/background_service_commands.dart';
import '../../domain/actuator/alert_actuator_command.dart';
import 'alert_actuator_command_background_payload.dart';

class AlertActuatorBackgroundServiceForwarder {
  final FlutterBackgroundService service;
  final AlertActuatorCommandBackgroundPayload payload;

  AlertActuatorBackgroundServiceForwarder({
    FlutterBackgroundService? service,
    this.payload = const AlertActuatorCommandBackgroundPayload(),
  }) : service = service ?? FlutterBackgroundService();

  Future<void> call(AlertActuatorCommand command) async {
    if (!Platform.isAndroid) return;
    if (!await service.isRunning()) return;
    service.invoke(
      BackgroundServiceCommands.alertActuatorCommand,
      payload.encode(command),
    );
  }
}
