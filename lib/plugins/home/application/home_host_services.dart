import 'package:flutter/foundation.dart';

import '../../../application/platform_runtime/platform_runtime_capability_snapshot.dart';
import '../../../application/sync_runtime/sync_runtime_policy.dart';
import '../../../application/sync_runtime/sync_runtime_status.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/sync_status/sync_status_snapshot.dart';

class HomeHostServices {
  final Listenable changeSignal;
  final Future<SyncStatusSnapshot> Function() syncStatusSnapshot;
  final SyncRuntimeStatus Function() syncRuntimeStatus;
  final Future<void> Function() switchToSelfSubject;
  final Future<void> Function(GlucoseUnit unit) updateUnit;

  const HomeHostServices({
    required this.changeSignal,
    required this.syncStatusSnapshot,
    SyncRuntimeStatus Function()? syncRuntimeStatus,
    required this.switchToSelfSubject,
    Future<void> Function(GlucoseUnit unit)? updateUnit,
  })  : syncRuntimeStatus = syncRuntimeStatus ?? _defaultSyncRuntimeStatus,
        updateUnit = updateUnit ?? _noopUpdateUnit;

  static SyncRuntimeStatus _defaultSyncRuntimeStatus() {
    return const SyncRuntimePolicy().evaluate(
      capability: const PlatformRuntimeCapabilitySnapshot.other().sync,
    );
  }

  static Future<void> _noopUpdateUnit(GlucoseUnit unit) async {}
}
