import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GlanceNotificationContent {
  final String title;
  final String body;
  final NotificationVisibility visibility;

  const GlanceNotificationContent({
    required this.title,
    required this.body,
    required this.visibility,
  });
}
