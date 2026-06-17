import 'package:smart_xdrip/application/plugin_text/sqlite_plugin_text_template_repository.dart';

import 'episode_detail_template_repository.dart';
import 'episode_detail_template_tables.dart';

class SqliteEpisodeDetailTemplateRepository
    extends SqlitePluginTextTemplateRepository
    implements EpisodeDetailTemplateRepository {
  const SqliteEpisodeDetailTemplateRepository({
    required super.databaseProvider,
  }) : super(
          tableName: EpisodeDetailTemplateTables.textTemplates,
        );
}
