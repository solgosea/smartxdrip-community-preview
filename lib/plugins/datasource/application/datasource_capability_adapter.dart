import 'package:smart_xdrip/application/data_source_runtime/data_source_runtime_coordinator.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/capabilities/datasource/datasource_capability.dart';

class DatasourceCapabilityAdapter implements DatasourceCapability {
  final DataSourceRuntimeCoordinator coordinator;
  final AppSettings Function() settingsProvider;

  const DatasourceCapabilityAdapter({
    required this.coordinator,
    required this.settingsProvider,
  });

  @override
  bool get hasConfiguredSource =>
      coordinator.snapshots.any((snapshot) => snapshot.configured);

  @override
  Future<void> requestSync({required String reason}) async {
    await coordinator.refresh(settings: settingsProvider());
  }
}
