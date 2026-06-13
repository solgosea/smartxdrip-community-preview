import 'package:sqflite/sqflite.dart';

import '../../../../domain/entities/app_settings.dart';
import '../../domain/widget_background_style.dart';
import '../../domain/widget_font_size.dart';
import '../../domain/widget_graph_range.dart';
import '../../domain/widget_tap_action.dart';
import '../../domain/widget_template.dart';
import 'glance_tables.dart';

class GlanceWidgetConfig {
  final int widgetId;
  final GlanceWidgetTemplate template;
  final GlanceWidgetBackgroundStyle backgroundStyle;
  final GlucoseUnit primaryUnit;
  final GlanceWidgetFontSize fontSize;
  final GlanceWidgetGraphRange graphRange;
  final bool showTrendArrow;
  final bool showDelta;
  final bool showLastUpdated;
  final bool showMiniGraph;
  final bool showAlternateUnit;
  final GlanceWidgetTapAction tapAction;

  const GlanceWidgetConfig({
    required this.widgetId,
    this.template = GlanceWidgetTemplate.trend,
    this.backgroundStyle = GlanceWidgetBackgroundStyle.dark,
    this.primaryUnit = GlucoseUnit.mmolL,
    this.fontSize = GlanceWidgetFontSize.medium,
    this.graphRange = GlanceWidgetGraphRange.fourHours,
    this.showTrendArrow = true,
    this.showDelta = true,
    this.showLastUpdated = true,
    this.showMiniGraph = true,
    this.showAlternateUnit = false,
    this.tapAction = GlanceWidgetTapAction.home,
  });

  GlanceWidgetConfig copyWith({
    int? widgetId,
    GlanceWidgetTemplate? template,
    GlanceWidgetBackgroundStyle? backgroundStyle,
    GlucoseUnit? primaryUnit,
    GlanceWidgetFontSize? fontSize,
    GlanceWidgetGraphRange? graphRange,
    bool? showTrendArrow,
    bool? showDelta,
    bool? showLastUpdated,
    bool? showMiniGraph,
    bool? showAlternateUnit,
    GlanceWidgetTapAction? tapAction,
  }) {
    return GlanceWidgetConfig(
      widgetId: widgetId ?? this.widgetId,
      template: template ?? this.template,
      backgroundStyle: backgroundStyle ?? this.backgroundStyle,
      primaryUnit: primaryUnit ?? this.primaryUnit,
      fontSize: fontSize ?? this.fontSize,
      graphRange: graphRange ?? this.graphRange,
      showTrendArrow: showTrendArrow ?? this.showTrendArrow,
      showDelta: showDelta ?? this.showDelta,
      showLastUpdated: showLastUpdated ?? this.showLastUpdated,
      showMiniGraph: showMiniGraph ?? this.showMiniGraph,
      showAlternateUnit: showAlternateUnit ?? this.showAlternateUnit,
      tapAction: tapAction ?? this.tapAction,
    );
  }
}

class SqliteGlanceWidgetConfigRepository {
  final Future<Database> Function() databaseProvider;

  const SqliteGlanceWidgetConfigRepository({
    required this.databaseProvider,
  });

  Future<GlanceWidgetConfig> getOrDefault(
      int widgetId, GlucoseUnit unit) async {
    final database = await databaseProvider();
    final rows = await database.query(
      GlanceTables.widgetConfigs,
      where: 'widget_id = ?',
      whereArgs: [widgetId],
      limit: 1,
    );
    if (rows.isEmpty) {
      return GlanceWidgetConfig(widgetId: widgetId, primaryUnit: unit);
    }
    return _fromRow(rows.first);
  }

  Future<List<GlanceWidgetConfig>> all() async {
    final database = await databaseProvider();
    final rows = await database.query(
      GlanceTables.widgetConfigs,
      orderBy: 'updated_at_ms DESC',
    );
    return rows.map(_fromRow).toList();
  }

  Future<void> save(GlanceWidgetConfig config) async {
    final database = await databaseProvider();
    final now = DateTime.now().millisecondsSinceEpoch;
    final existing = await database.query(
      GlanceTables.widgetConfigs,
      columns: const ['created_at_ms'],
      where: 'widget_id = ?',
      whereArgs: [config.widgetId],
      limit: 1,
    );
    await database.insert(
      GlanceTables.widgetConfigs,
      {
        'widget_id': config.widgetId,
        'template': config.template.code,
        'background_style': config.backgroundStyle.code,
        'primary_unit': _unitCode(config.primaryUnit),
        'font_size': config.fontSize.code,
        'graph_range': config.graphRange.code,
        'show_trend_arrow': config.showTrendArrow ? 1 : 0,
        'show_delta': config.showDelta ? 1 : 0,
        'show_last_updated': config.showLastUpdated ? 1 : 0,
        'show_mini_graph': config.showMiniGraph ? 1 : 0,
        'show_alternate_unit': config.showAlternateUnit ? 1 : 0,
        'tap_action': config.tapAction.code,
        'created_at_ms': existing.isEmpty
            ? now
            : existing.first['created_at_ms'] as int? ?? now,
        'updated_at_ms': now,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  GlanceWidgetConfig _fromRow(Map<String, Object?> row) {
    return GlanceWidgetConfig(
      widgetId: row['widget_id'] as int,
      template: GlanceWidgetTemplate.fromCode(row['template'] as String?),
      backgroundStyle: GlanceWidgetBackgroundStyle.fromCode(
        row['background_style'] as String?,
      ),
      primaryUnit: _unit(row['primary_unit'] as String?),
      fontSize: GlanceWidgetFontSize.fromCode(row['font_size'] as String?),
      graphRange:
          GlanceWidgetGraphRange.fromCode(row['graph_range'] as String?),
      showTrendArrow: row['show_trend_arrow'] == 1,
      showDelta: row['show_delta'] == 1,
      showLastUpdated: row['show_last_updated'] == 1,
      showMiniGraph: row['show_mini_graph'] == 1,
      showAlternateUnit: row['show_alternate_unit'] == 1,
      tapAction: GlanceWidgetTapAction.fromCode(row['tap_action'] as String?),
    );
  }

  GlucoseUnit _unit(String? code) {
    return switch (code) {
      'mg_dl' => GlucoseUnit.mgDl,
      _ => GlucoseUnit.mmolL,
    };
  }

  String _unitCode(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 'mmol_l',
      GlucoseUnit.mgDl => 'mg_dl',
    };
  }
}
