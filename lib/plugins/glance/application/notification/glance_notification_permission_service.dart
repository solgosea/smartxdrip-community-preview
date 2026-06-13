import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class GlanceNotificationPermissionService {
  final FlutterLocalNotificationsPlugin plugin;

  const GlanceNotificationPermissionService({
    required this.plugin,
  });

  Future<bool> requestPermission() async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final enabled = await androidPlugin?.areNotificationsEnabled();
    if (enabled == true) return true;
    return await androidPlugin?.requestNotificationsPermission() ?? true;
  }

  Future<bool> areNotificationsEnabled() async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.areNotificationsEnabled() ?? true;
  }
}
