import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_contributor.dart';
import 'package:smart_xdrip/plugin_platform/schema/plugin_schema_context.dart';

import '../sqlite/episode_detail_template_schema.dart';

class EpisodeDetailTemplateSchemaContributor extends PluginSchemaContributor {
  const EpisodeDetailTemplateSchemaContributor();

  @override
  String get pluginId => 'explore.episode_detail';

  @override
  int get schemaVersion => 1;

  @override
  Future<void> install(PluginSchemaContext context) {
    return const EpisodeDetailTemplateSchema().install(context.database);
  }
}
