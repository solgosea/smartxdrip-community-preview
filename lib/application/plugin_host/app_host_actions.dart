import '../../domain/entities/app_settings.dart';

class AppHostActions {
  final Future<void> Function(AppSettings next) updateSettings;
  final Future<void> Function() clearAllData;
  final Future<void> Function() switchToSelfSubject;

  const AppHostActions({
    required this.updateSettings,
    required this.clearAllData,
    required this.switchToSelfSubject,
  });
}
