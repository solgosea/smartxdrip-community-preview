import 'package:sqflite/sqflite.dart';

import '../../domain/notification_privacy_mode.dart';
import 'glance_tables.dart';

class GlanceNotificationSettings {
  final bool enabled;
  final GlanceNotificationPrivacyMode privacyMode;
  final bool quickActionsEnabled;
  final bool lowBatteryMode;

  const GlanceNotificationSettings({
    this.enabled = false,
    this.privacyMode = GlanceNotificationPrivacyMode.private,
    this.quickActionsEnabled = true,
    this.lowBatteryMode = false,
  });

  GlanceNotificationSettings copyWith({
    bool? enabled,
    GlanceNotificationPrivacyMode? privacyMode,
    bool? quickActionsEnabled,
    bool? lowBatteryMode,
  }) {
    return GlanceNotificationSettings(
      enabled: enabled ?? this.enabled,
      privacyMode: privacyMode ?? this.privacyMode,
      quickActionsEnabled: quickActionsEnabled ?? this.quickActionsEnabled,
      lowBatteryMode: lowBatteryMode ?? this.lowBatteryMode,
    );
  }
}

class SqliteGlanceSettingsRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteGlanceSettingsRepository({
    required this.databaseProvider,
  });

  Future<GlanceNotificationSettings> get() async {
    final database = await databaseProvider();
    final rows = await database.query(
      GlanceTables.notificationSettings,
      where: 'id = 1',
      limit: 1,
    );
    if (rows.isEmpty) return const GlanceNotificationSettings();
    final row = rows.first;
    return GlanceNotificationSettings(
      enabled: row['enabled'] == 1,
      privacyMode: GlanceNotificationPrivacyMode.fromCode(
        row['privacy_mode'] as String?,
      ),
      quickActionsEnabled: row['quick_actions_enabled'] == 1,
      lowBatteryMode: row['low_battery_mode'] == 1,
    );
  }

  Future<void> save(GlanceNotificationSettings settings) async {
    final database = await databaseProvider();
    await database.insert(
      GlanceTables.notificationSettings,
      {
        'id': 1,
        'enabled': settings.enabled ? 1 : 0,
        'privacy_mode': settings.privacyMode.code,
        'quick_actions_enabled': settings.quickActionsEnabled ? 1 : 0,
        'low_battery_mode': settings.lowBatteryMode ? 1 : 0,
        'updated_at_ms': DateTime.now().millisecondsSinceEpoch,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
