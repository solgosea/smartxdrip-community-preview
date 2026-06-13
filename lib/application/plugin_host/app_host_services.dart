import 'package:flutter/foundation.dart';

import '../../application/analysis/analysis_facade.dart';
import '../../application/sync_runtime/sync_runtime_status.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';

class AppHostServices {
  final Listenable changeSignal;
  final AnalysisFacade Function() facadeProvider;
  final AppSettings Function() settingsProvider;
  final Future<SyncStatusSnapshot> Function() syncStatusSnapshot;
  final SyncRuntimeStatus Function() syncRuntimeStatus;
  final Future<int?> Function() databaseFileSizeBytes;
  final Future<List<GlucoseReading>> Function(int days) readingsForDays;

  const AppHostServices({
    required this.changeSignal,
    required this.facadeProvider,
    required this.settingsProvider,
    required this.syncStatusSnapshot,
    required this.syncRuntimeStatus,
    required this.databaseFileSizeBytes,
    required this.readingsForDays,
  });
}
