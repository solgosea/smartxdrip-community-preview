import 'package:flutter/foundation.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

import '../application/profile_host_services.dart';
import '../models/profile_view_model.dart';
import '../runtime/profile_plugin_runtime.dart';
import '../runtime/profile_runtime_cache.dart';

class ProfileController extends ChangeNotifier {
  final ProfileHostServices hostServices;
  final ProfileRuntimeCache runtimeCache;
  final ProfilePluginRuntime runtime;

  ProfileViewModel? _viewModel;
  bool _disposed = false;

  ProfileController({
    required this.hostServices,
    required this.runtimeCache,
    required this.runtime,
  }) {
    hostServices.changeSignal.addListener(_handleHostChanged);
  }

  ProfileViewModel? get viewModel => _viewModel;

  AppSettings get currentSettings => hostServices.settingsProvider();

  Future<void> load() async {
    final facade = hostServices.facadeProvider();
    final cached = runtimeCache.freshSnapshot(
      subjectId: facade.activeSubject.id,
    );
    if (cached != null) {
      _viewModel = cached.viewModel;
      _notifyIfActive();
      return;
    }

    final snapshot = await runtime.preheat();
    if (snapshot == null) return;
    _viewModel = snapshot.viewModel;
    _notifyIfActive();
  }

  void _handleHostChanged() {
    runtimeCache.markStale('hostChanged');
    load();
  }

  void _notifyIfActive() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    hostServices.changeSignal.removeListener(_handleHostChanged);
    super.dispose();
  }
}
