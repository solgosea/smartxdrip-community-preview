import 'package:smart_xdrip/application/nightscout/nightscout_url_normalizer.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_kind.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_registry.dart';
import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_status.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/subject/glucose_subject.dart';

class DatasourceNightscoutTargetPublisher {
  static const targetId = 'self:nightscout';

  final NightscoutSyncTargetRegistry registry;
  final DateTime Function() clock;

  const DatasourceNightscoutTargetPublisher({
    required this.registry,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  void publishFromSettings(AppSettings settings) {
    final normalized = NightscoutUrlNormalizer.normalize(
      settings.nightscoutBaseUrl ?? '',
    );
    if (normalized == null || normalized.isEmpty) {
      registry.remove(targetId);
      return;
    }
    registry.upsert(
      NightscoutSyncTarget(
        targetId: targetId,
        kind: NightscoutSyncTargetKind.selfDatasource,
        subjectId: GlucoseSubject.selfId,
        label: 'Self Nightscout',
        normalizedUrl: normalized,
        accessToken: _token(settings.nightscoutToken),
        accessTokenFingerprint:
            _token(settings.nightscoutToken) == null ? null : 'configured',
        ownerPluginId: 'datasource.core',
        status: settings.nightscoutSyncEnabled
            ? NightscoutSyncTargetStatus.active
            : NightscoutSyncTargetStatus.disabled,
        updatedAt: clock(),
        metadata: const {'source': 'datasource'},
      ),
    );
  }

  String? _token(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
