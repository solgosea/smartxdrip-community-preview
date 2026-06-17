import 'package:smart_xdrip/application/plugin_text/plugin_text_template_schema.dart';
import 'package:sqflite/sqflite.dart';

import 'history_template_tables.dart';

class HistoryTemplateSchema {
  const HistoryTemplateSchema();

  Future<void> install(Database database) {
    return const PluginTextTemplateSchema(
      HistoryTemplateTables.textTemplates,
    ).install(database);
  }
}
