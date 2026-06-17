import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_contributor.dart';

import '../sqlite/history_template_schema.dart';

class HistoryTemplateSchemaContributor extends PluginSchemaContributor {
  const HistoryTemplateSchemaContributor();

  @override
  String get pluginId => 'core.history';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const HistoryTemplateSchema().install(context.database);
  }

  @override
  Future<void> migrate(
    PluginSchemaContext context, {
    required int fromVersion,
    required int toVersion,
  }) {
    return install(context);
  }
}
