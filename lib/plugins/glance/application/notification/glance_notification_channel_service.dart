import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'glance_notification_channels.dart';

class GlanceNotificationChannelService {
  final FlutterLocalNotificationsPlugin plugin;

  const GlanceNotificationChannelService({
    required this.plugin,
  });

  Future<void> ensureConfigured() async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        GlanceNotificationChannels.lockScreen,
        'Glance status',
        description: 'Lock screen glucose status without sound or vibration.',
        importance: Importance.high,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      ),
    );
  }
}
