import '../mappers/profile_view_model_mapper.dart';
import '../runtime/profile_runtime_cache.dart';
import 'profile_host_services.dart';

class ProfileSnapshotPreheater {
  final ProfileHostServices hostServices;
  final ProfileViewModelMapper mapper;
  final DateTime Function() now;

  const ProfileSnapshotPreheater({
    required this.hostServices,
    this.mapper = const ProfileViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<ProfileRuntimeSnapshot> preheat() async {
    final facade = hostServices.facadeProvider();
    final settings = hostServices.settingsProvider();
    return ProfileRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      viewModel: mapper.map(
        facade: facade,
        settings: settings,
      ),
      updatedAt: now(),
    );
  }
}
