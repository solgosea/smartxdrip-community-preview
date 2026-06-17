import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';

import '../application/episode_detail_service.dart';
import '../domain/episode_detail_entry_intent.dart';
import '../mappers/episode_detail_view_model_mapper.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import '../runtime/episode_detail_plugin_runtime.dart';
import '../runtime/episode_detail_runtime_cache.dart';
import '../runtime/episode_detail_runtime_snapshot.dart';

class EpisodeDetailController extends ChangeNotifier {
  final EpisodeDetailEntryIntent intent;
  final EpisodeDetailRuntimeCache? runtimeCache;
  final EpisodeDetailPluginRuntime? runtime;
  final PluginRuntimeContext? runtimeContext;
  final EpisodeDetailService? service;
  final EpisodeDetailViewModelMapper mapper;

  EpisodeDetailViewModel? _viewModel;
  bool _disposed = false;
  int _loadVersion = 0;

  EpisodeDetailController({
    required this.intent,
    this.runtimeCache,
    this.runtime,
    this.runtimeContext,
    this.service,
    this.mapper = const EpisodeDetailViewModelMapper(),
  });

  EpisodeDetailViewModel? get viewModel => _viewModel;

  EpisodeKind get kind => intent.kind;

  Future<void> load() async {
    if (_disposed) return;
    final version = ++_loadVersion;
    final facade = AnalysisFacade.current();
    final cached = runtimeCache?.freshSnapshot(
      subjectId: facade.activeSubject.id,
      kind: kind,
      focus: intent.focus,
    );
    final next = cached?.viewModel ?? await _preheatOrMap(facade: facade);
    if (_disposed || version != _loadVersion) return;
    _viewModel = next;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _loadVersion++;
    super.dispose();
  }

  Future<EpisodeDetailViewModel> _preheatOrMap({
    required AnalysisFacade facade,
  }) async {
    final context = runtimeContext;
    final snapshot = intent.isFocused || context == null
        ? null
        : await runtime?.preheatKind(
            context,
            kind: kind,
            reason: 'controller',
          );
    if (snapshot != null) return snapshot.viewModel;
    final effectiveService = service ??
        EpisodeDetailService(
          facadeProvider: AnalysisFacade.current,
        );
    final output = effectiveService.load(intent: intent);
    final viewModel = mapper.map(output);
    runtimeCache?.put(
      EpisodeDetailRuntimeSnapshot(
        subjectId: output.query.subjectId,
        kind: kind,
        focus: intent.focus,
        viewModel: viewModel,
        updatedAt: DateTime.now(),
        reason: intent.isFocused ? 'focused' : 'controller',
      ),
    );
    return viewModel;
  }
}
