import 'package:sqflite/sqflite.dart';
import 'package:smart_xdrip/application/plugin_text/plugin_text_template_schema.dart';

import 'episode_detail_template_tables.dart';

class EpisodeDetailTemplateSchema {
  const EpisodeDetailTemplateSchema();

  Future<void> install(Database database) {
    return const PluginTextTemplateSchema(
      EpisodeDetailTemplateTables.textTemplates,
    ).install(database);
  }
}
