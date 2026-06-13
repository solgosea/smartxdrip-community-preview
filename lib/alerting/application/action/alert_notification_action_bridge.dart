import '../../domain/action/alert_action.dart';
import '../../domain/action/alert_action_result.dart';
import '../../domain/repository/alert_event_repository.dart';
import '../../infrastructure/local_notifications/alert_notification_action_ids.dart';
import '../../infrastructure/local_notifications/alert_notification_payload_codec.dart';
import 'alert_action_orchestrator.dart';

class AlertNotificationActionBridge {
  final AlertEventRepository eventRepository;
  final AlertActionOrchestrator actionOrchestrator;
  final AlertNotificationPayloadCodec payloadCodec;

  const AlertNotificationActionBridge({
    required this.eventRepository,
    required this.actionOrchestrator,
    this.payloadCodec = const AlertNotificationPayloadCodec(),
  });

  Future<AlertActionResult> handle({
    required String actionId,
    required String? payload,
  }) async {
    final action = _actionFor(actionId);
    if (action == null) {
      return const AlertActionResult(
        success: false,
        message: 'Unsupported notification action.',
      );
    }
    final decoded = payloadCodec.decode(payload);
    if (decoded == null) {
      return const AlertActionResult(
        success: false,
        message: 'Notification payload is missing alert event id.',
      );
    }
    final event = await eventRepository.byId(decoded.alertEventId);
    if (event == null) {
      return const AlertActionResult(
        success: false,
        message: 'Alert event no longer exists.',
      );
    }
    return actionOrchestrator.apply(
      event,
      action,
      actor: 'system_notification',
    );
  }

  AlertAction? _actionFor(String actionId) {
    return switch (actionId) {
      AlertNotificationActionIds.snooze => AlertAction.snooze,
      AlertNotificationActionIds.dismiss => AlertAction.dismiss,
      _ => null,
    };
  }
}
