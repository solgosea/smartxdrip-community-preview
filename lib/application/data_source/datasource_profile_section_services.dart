import 'package:flutter/foundation.dart';

import '../platform_runtime/platform_runtime_capability_snapshot.dart';
import '../sync_runtime/sync_runtime_status.dart';
import '../../domain/data_source/data_source_connection_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';

class DatasourceProfileSectionServices {
  final Listenable changeSignal;
  final AppSettings Function() settingsProvider;
  final Future<SyncStatusSnapshot> Function() syncStatusSnapshot;
  final SyncRuntimeStatus Function() syncRuntimeStatus;
  final PlatformRuntimeCapabilitySnapshot Function() platformCapabilities;
  final bool Function() xdripSupported;
  final Future<List<DataSourceConnectionSnapshot>> Function({
    required bool xdripSupported,
  }) dataSourceSnapshots;

  const DatasourceProfileSectionServices({
    required this.changeSignal,
    required this.settingsProvider,
    required this.syncStatusSnapshot,
    required this.syncRuntimeStatus,
    required this.platformCapabilities,
    required this.xdripSupported,
    required this.dataSourceSnapshots,
  });
}
