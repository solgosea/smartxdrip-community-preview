import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';
import 'glance_notification_content.dart';

class GlanceNotificationContentBuilder {
  const GlanceNotificationContentBuilder();

  GlanceNotificationContent build({
    required GlanceSnapshot snapshot,
    required GlanceNotificationPrivacyMode privacyMode,
  }) {
    final private = privacyMode == GlanceNotificationPrivacyMode.private;
    return GlanceNotificationContent(
      title: private ? 'Glucose data available' : 'SmartXDrip',
      body: private
          ? 'Unlock to view current glucose'
          : '${snapshot.valueLabel} ${snapshot.unitLabel}  '
              '${snapshot.trendArrow}  ${snapshot.deltaLabel}  '
              '${snapshot.freshness.label}',
      visibility: private
          ? NotificationVisibility.private
          : NotificationVisibility.public,
    );
  }
}
