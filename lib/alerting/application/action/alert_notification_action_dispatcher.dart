import '../../domain/action/alert_action_result.dart';
import 'alert_notification_action_bridge.dart';

class AlertNotificationActionDispatcher {
  final AlertNotificationActionBridge bridge;

  const AlertNotificationActionDispatcher({
    required this.bridge,
  });

  Future<AlertActionResult> dispatch({
    required String actionId,
    required String? payload,
  }) {
    return bridge.handle(actionId: actionId, payload: payload);
  }
}
