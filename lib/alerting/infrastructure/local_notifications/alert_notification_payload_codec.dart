import 'dart:convert';

class AlertNotificationPayload {
  final String alertEventId;

  const AlertNotificationPayload({
    required this.alertEventId,
  });
}

class AlertNotificationPayloadCodec {
  static const _type = 'smartxdrip.alert';
  static const _version = 1;

  const AlertNotificationPayloadCodec();

  String encode({
    required String alertEventId,
  }) {
    return jsonEncode({
      'type': _type,
      'version': _version,
      'alertEventId': alertEventId,
    });
  }

  AlertNotificationPayload? decode(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map) return null;
      final map = decoded.cast<String, Object?>();
      if (map['type'] != _type) return null;
      final alertEventId = map['alertEventId'] as String?;
      if (alertEventId == null || alertEventId.isEmpty) return null;
      return AlertNotificationPayload(alertEventId: alertEventId);
    } catch (_) {
      // Raw payloads are treated as event ids so notification actions remain usable.
      return AlertNotificationPayload(alertEventId: payload);
    }
  }
}
