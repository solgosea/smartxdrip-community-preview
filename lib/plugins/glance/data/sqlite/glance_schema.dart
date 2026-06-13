import 'package:sqflite/sqflite.dart';

import 'glance_tables.dart';

class GlanceSchema {
  const GlanceSchema();

  Future<void> install(Database database) async {
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${GlanceTables.widgetConfigs} (
        widget_id INTEGER PRIMARY KEY,
        template TEXT NOT NULL,
        background_style TEXT NOT NULL,
        primary_unit TEXT NOT NULL,
        font_size TEXT NOT NULL,
        graph_range TEXT NOT NULL,
        show_trend_arrow INTEGER NOT NULL,
        show_delta INTEGER NOT NULL,
        show_last_updated INTEGER NOT NULL,
        show_mini_graph INTEGER NOT NULL,
        show_alternate_unit INTEGER NOT NULL,
        tap_action TEXT NOT NULL,
        created_at_ms INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
    await database.execute('''
      CREATE TABLE IF NOT EXISTS ${GlanceTables.notificationSettings} (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        enabled INTEGER NOT NULL,
        privacy_mode TEXT NOT NULL,
        quick_actions_enabled INTEGER NOT NULL,
        low_battery_mode INTEGER NOT NULL,
        updated_at_ms INTEGER NOT NULL
      )
    ''');
  }
}
