import 'package:flutter/foundation.dart';

import '../../application/glance_persistent_notification_service.dart';
import '../../application/glance_snapshot_service.dart';
import '../../data/sqlite/sqlite_glance_settings_repository.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';

class GlanceHubController extends ChangeNotifier {
  final GlanceSnapshotService snapshotService;
  final SqliteGlanceSettingsRepository settingsRepository;
  final GlancePersistentNotificationService notificationService;

  GlanceSnapshot? snapshot;
  GlanceNotificationSettings settings = const GlanceNotificationSettings();
  bool loading = true;
  bool notificationPermissionDenied = false;

  GlanceHubController({
    required this.snapshotService,
    required this.settingsRepository,
    required this.notificationService,
  });

  Future<void> load() async {
    loading = true;
    notifyListeners();
    snapshot = await snapshotService.current();
    settings = await settingsRepository.get();
    loading = false;
    notifyListeners();
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    if (enabled && !await notificationService.requestPermission()) {
      notificationPermissionDenied = true;
      settings = settings.copyWith(enabled: false);
      await settingsRepository.save(settings);
      await notificationService.cancel();
      notifyListeners();
      return;
    }
    notificationPermissionDenied = false;
    settings = settings.copyWith(enabled: enabled);
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    if (enabled) {
      await notificationService.update(current);
    } else {
      await notificationService.cancel();
    }
    notifyListeners();
  }

  Future<void> setPrivateMode(bool enabled) async {
    settings = settings.copyWith(
      privacyMode: enabled
          ? GlanceNotificationPrivacyMode.private
          : GlanceNotificationPrivacyMode.full,
    );
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setLockScreenGlucoseVisible(bool visible) async {
    notificationPermissionDenied = false;
    var next = settings.copyWith(
      enabled: true,
      privacyMode: visible
          ? GlanceNotificationPrivacyMode.full
          : GlanceNotificationPrivacyMode.private,
    );
    if (!await notificationService.requestPermission()) {
      notificationPermissionDenied = true;
      next = next.copyWith(enabled: false);
      settings = next;
      await settingsRepository.save(settings);
      await notificationService.cancel();
      notifyListeners();
      return;
    }
    settings = next;
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setQuickActionsEnabled(bool enabled) async {
    settings = settings.copyWith(quickActionsEnabled: enabled);
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setLowBatteryMode(bool enabled) async {
    settings = settings.copyWith(lowBatteryMode: enabled);
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }
}
