import 'package:smart_xdrip/application/plugin_text/sqlite_plugin_text_template_repository.dart';

import 'history_template_repository.dart';
import 'history_template_tables.dart';

class SqliteHistoryTemplateRepository extends SqlitePluginTextTemplateRepository
    implements HistoryTemplateRepository {
  const SqliteHistoryTemplateRepository({
    required super.databaseProvider,
  }) : super(
          tableName: HistoryTemplateTables.textTemplates,
        );
}
