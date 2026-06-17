import '../../../../application/analysis/analysis_facade.dart';
import '../../../../data/local/glucose_database.dart';
import '../../../../plugin_platform/install/plugin_install_context.dart';
import '../../../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import '../application/episode_detail_snapshot_preheater.dart';
import '../application/text/episode_detail_text_template_installer.dart';
import '../data/schema/episode_detail_template_schema_contributor.dart';
import '../data/sqlite/episode_detail_template_repository.dart';
import '../data/sqlite/sqlite_episode_detail_template_repository.dart';
import '../runtime/episode_detail_plugin_runtime.dart';
import '../runtime/episode_detail_runtime_cache.dart';

class EpisodeDetailRuntimeInstaller {
  const EpisodeDetailRuntimeInstaller._();

  static void install(PluginInstallContext context) {
    context.registerSchema(const EpisodeDetailTemplateSchemaContributor());
    final existingCache = context.services.maybe<EpisodeDetailRuntimeCache>();
    final existingRuntime =
        context.services.maybe<EpisodeDetailPluginRuntime>();
    final existingInstaller =
        context.services.maybe<EpisodeDetailTextTemplateInstaller>();
    final textTemplateInstaller =
        existingInstaller ?? _textTemplateInstaller(context);
    if (existingInstaller == null && textTemplateInstaller != null) {
      context.services.register<EpisodeDetailTextTemplateInstaller>(
        textTemplateInstaller,
      );
    }
    if (existingCache != null && existingRuntime != null) return;

    final cache = existingCache ?? EpisodeDetailRuntimeCache();
    final runtime = existingRuntime ??
        EpisodeDetailPluginRuntime(
          cache: cache,
          preheater: EpisodeDetailSnapshotPreheater(
            facadeProvider: AnalysisFacade.current,
          ),
          textTemplateInstaller: textTemplateInstaller,
        );

    if (existingCache == null) {
      context.services.register<EpisodeDetailRuntimeCache>(cache);
    }
    if (existingRuntime == null) {
      context.services.register<EpisodeDetailPluginRuntime>(runtime);
      context.registerRuntime(
        runtime,
        startPolicy: PluginRuntimeStartPolicy.onEnter,
      );
    }
  }

  static EpisodeDetailTextTemplateInstaller? _textTemplateInstaller(
    PluginInstallContext context,
  ) {
    final repository = _templateRepository(context);
    if (repository == null) return null;
    return EpisodeDetailTextTemplateInstaller(repository: repository);
  }

  static EpisodeDetailTemplateRepository? _templateRepository(
    PluginInstallContext context,
  ) {
    final existing = context.services.maybe<EpisodeDetailTemplateRepository>();
    if (existing != null) return existing;
    final database = context.services.maybe<GlucoseDatabase>();
    if (database == null) return null;
    final repository = SqliteEpisodeDetailTemplateRepository(
      databaseProvider: () => database.db,
    );
    context.services.register<EpisodeDetailTemplateRepository>(repository);
    return repository;
  }
}
