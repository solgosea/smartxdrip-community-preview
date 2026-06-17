import 'package:flutter/foundation.dart';

import '../../application/glance_persistent_notification_service.dart';
import '../../application/glance_snapshot_service.dart';
import '../../application/floating/floating_glance_service.dart';
import '../../data/sqlite/sqlite_floating_glance_settings_repository.dart';
import '../../data/sqlite/sqlite_glance_settings_repository.dart';
import '../../domain/glance_display_mode.dart';
import '../../domain/glance_lock_screen_mode.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/notification_privacy_mode.dart';
import '../../domain/floating/floating_glance_mode.dart';
import '../../domain/floating/floating_glance_settings.dart';
import '../../domain/floating/floating_glance_setup_state.dart';

class GlanceHubController extends ChangeNotifier {
  final GlanceSnapshotService snapshotService;
  final SqliteGlanceSettingsRepository settingsRepository;
  final GlancePersistentNotificationService notificationService;
  final SqliteFloatingGlanceSettingsRepository? floatingSettingsRepository;
  final FloatingGlanceService? floatingService;

  GlanceSnapshot? snapshot;
  GlanceNotificationSettings settings = const GlanceNotificationSettings();
  FloatingGlanceSettings floatingSettings = const FloatingGlanceSettings();
  bool loading = true;
  bool notificationPermissionDenied = false;
  bool floatingPermissionGranted = false;

  GlanceHubController({
    required this.snapshotService,
    required this.settingsRepository,
    required this.notificationService,
    this.floatingSettingsRepository,
    this.floatingService,
  });

  FloatingGlanceSetupState get floatingSetupState {
    if (floatingService == null || floatingSettingsRepository == null) {
      return FloatingGlanceSetupState.unavailable;
    }
    if (!floatingPermissionGranted) {
      return FloatingGlanceSetupState.permissionNeeded;
    }
    if (floatingSettings.enabled) {
      return FloatingGlanceSetupState.visible;
    }
    if (floatingSettings.dismissedForSession) {
      return FloatingGlanceSetupState.hidden;
    }
    return FloatingGlanceSetupState.permissionGranted;
  }

  Future<void> load() async {
    loading = true;
    notifyListeners();
    snapshot = await snapshotService.current();
    settings = await settingsRepository.get();
    try {
      floatingSettings = await floatingSettingsRepository?.get() ??
          const FloatingGlanceSettings();
      floatingPermissionGranted =
          await floatingService?.hasPermission() ?? false;
    } catch (_) {
      floatingSettings = const FloatingGlanceSettings();
      floatingPermissionGranted = false;
    }
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
      lockScreenMode: enabled
          ? GlanceLockScreenMode.private
          : GlanceLockScreenMode.fullValue,
      notificationDisplayMode:
          enabled ? GlanceDisplayMode.private : GlanceDisplayMode.fullValue,
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
      lockScreenMode: visible
          ? GlanceLockScreenMode.fullValue
          : GlanceLockScreenMode.private,
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

  Future<void> setLockScreenMode(GlanceLockScreenMode mode) async {
    final enabled = mode != GlanceLockScreenMode.off;
    if (enabled && !await notificationService.requestPermission()) {
      notificationPermissionDenied = true;
      settings = settings.copyWith(enabled: false, lockScreenMode: mode);
      await settingsRepository.save(settings);
      await notificationService.cancel();
      notifyListeners();
      return;
    }
    notificationPermissionDenied = false;
    settings = settings.copyWith(
      enabled: enabled || settings.enabled,
      lockScreenMode: mode,
      privacyMode: mode == GlanceLockScreenMode.private
          ? GlanceNotificationPrivacyMode.private
          : GlanceNotificationPrivacyMode.full,
    );
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setNotificationDisplayMode(GlanceDisplayMode mode) async {
    settings = settings.copyWith(
      notificationDisplayMode: mode,
      privacyMode: mode == GlanceDisplayMode.private
          ? GlanceNotificationPrivacyMode.private
          : GlanceNotificationPrivacyMode.full,
    );
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setAodFriendlyEnabled(bool enabled) async {
    settings = settings.copyWith(aodFriendlyEnabled: enabled);
    await settingsRepository.save(settings);
    final current = snapshot ?? await snapshotService.current();
    await notificationService.update(current);
    notifyListeners();
  }

  Future<void> setFloatingEnabled(bool enabled) async {
    if (enabled) {
      await showFloatingGlance();
    } else {
      await hideFloatingGlance();
    }
  }

  Future<void> refreshFloatingPermission() async {
    final service = floatingService;
    if (service == null) return;
    floatingPermissionGranted = await service.hasPermission();
    if (floatingPermissionGranted && floatingSettings.enabled) {
      final current = snapshot ?? await snapshotService.current();
      snapshot = current;
      await service.show(current);
    }
    notifyListeners();
  }

  Future<void> showFloatingGlance() async {
    final repository = floatingSettingsRepository;
    if (repository == null) return;
    final service = floatingService;
    floatingPermissionGranted = await service?.hasPermission() ?? false;
    if (!floatingPermissionGranted) {
      await requestFloatingPermission();
      return;
    }
    floatingSettings = floatingSettings.copyWith(
      mode: FloatingGlanceMode.enabled,
      dismissedForSession: false,
    );
    await repository.save(floatingSettings);
    if (service != null) {
      final current = snapshot ?? await snapshotService.current();
      snapshot = current;
      await service.show(current);
    }
    notifyListeners();
  }

  Future<void> hideFloatingGlance() async {
    final repository = floatingSettingsRepository;
    if (repository == null) return;
    floatingSettings = floatingSettings.copyWith(
      mode: FloatingGlanceMode.disabled,
      dismissedForSession: true,
    );
    await repository.save(floatingSettings);
    await floatingService?.hide();
    notifyListeners();
  }

  Future<void> requestFloatingPermission() async {
    final service = floatingService;
    if (service == null) return;
    if (floatingSettings.enabled) {
      floatingSettings = floatingSettings.copyWith(
        mode: FloatingGlanceMode.disabled,
        dismissedForSession: false,
      );
      await floatingSettingsRepository?.save(floatingSettings);
      await service.hide();
    }
    await service.requestPermission();
    floatingPermissionGranted = await service.hasPermission();
    notifyListeners();
  }
}
