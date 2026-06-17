import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/plugin_platform/runtime/contracts/plugin_runtime_context.dart';

import '../../../../application/analysis/analysis_facade.dart';
import '../application/report_default_sections.dart';
import '../application/report_export_use_case.dart';
import '../application/report_service.dart';
import '../models/report_period.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';
import '../runtime/report_plugin_runtime.dart';
import '../runtime/report_runtime_cache.dart';
import '../services/report_export_service.dart' show ReportExportAction;

class ReportController extends ChangeNotifier {
  final Listenable changeSignal;
  final ReportService service;
  final ReportExportUseCase exportUseCase;
  final ReportRuntimeCache? runtimeCache;
  final ReportPluginRuntime? runtime;
  final PluginRuntimeContext? runtimeContext;

  ReportPeriod _selectedPeriod = ReportPeriod.days30;
  ReportViewModel? _viewModel;
  bool _loading = false;
  bool _exporting = false;
  bool _disposed = false;
  int _loadVersion = 0;
  List<ReportSectionToggle> _sections = defaultSections;

  ReportController({
    required this.changeSignal,
    this.service = const ReportService(),
    ReportExportUseCase? exportUseCase,
    this.runtimeCache,
    this.runtime,
    this.runtimeContext,
  }) : exportUseCase = exportUseCase ?? const ReportExportUseCase() {
    changeSignal.addListener(_handleHostChanged);
  }

  ReportViewModel? get viewModel => _viewModel;
  bool get loading => _loading;
  bool get exporting => _exporting;

  Future<void> load() async {
    final version = ++_loadVersion;
    _loading = true;
    _notify();
    final facade = AnalysisFacade.current();
    final cached = runtimeCache?.freshSnapshot(
      subjectId: facade.activeSubject.id,
      period: _selectedPeriod,
      sections: _sections,
    );
    if (cached != null) {
      if (_disposed || version != _loadVersion) return;
      _viewModel = cached.viewModel;
      _loading = false;
      _notify();
      return;
    }
    final next = await _preheatOrAnalyze(
      facade: facade,
      period: _selectedPeriod,
      sections: _sections,
    );
    if (_disposed || version != _loadVersion) return;
    _viewModel = next;
    _loading = false;
    _notify();
  }

  Future<void> selectPeriod(ReportPeriod period) async {
    if (_disposed || period == _selectedPeriod) return;
    _selectedPeriod = period;
    await load();
  }

  void toggleSection(ReportSectionKey key) {
    _sections = [
      for (final section in _sections)
        if (section.key == key)
          section.copyWith(enabled: !section.enabled)
        else
          section,
    ];
    final current = _viewModel;
    if (current != null) {
      _viewModel = current.copyWith(sections: _sections);
      _notify();
    }
  }

  Future<void> export(ReportExportAction action) async {
    final current = _viewModel;
    if (current == null || _exporting || !current.hasData) return;
    _exporting = true;
    _notify();
    try {
      await exportUseCase.execute(current, action: action);
    } finally {
      if (!_disposed) {
        _exporting = false;
        _notify();
      }
    }
  }

  Future<void> _handleHostChanged() async {
    if (_disposed) return;
    await load();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<ReportViewModel> _preheatOrAnalyze({
    required AnalysisFacade facade,
    required ReportPeriod period,
    required List<ReportSectionToggle> sections,
  }) async {
    final context = runtimeContext;
    final snapshot = context == null
        ? null
        : await runtime?.preheatPeriod(
            context,
            period: period,
            sections: sections,
            reason: 'controller',
          );
    if (snapshot != null) return snapshot.viewModel;

    return service.buildFromFacade(
      facade: facade,
      period: period,
      sections: sections,
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _loadVersion++;
    changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }

  static const defaultSections = ReportDefaultSections.values;
}
