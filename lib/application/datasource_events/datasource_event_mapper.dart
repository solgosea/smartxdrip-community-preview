import '../../domain/data_source/data_source_connection_snapshot.dart';
import '../../domain/data_source/data_source_connection_status.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/subject/analysis_subject.dart';
import 'datasource_event.dart';
import 'datasource_event_payload.dart';
import 'datasource_event_type.dart';

class DatasourceEventMapper {
  const DatasourceEventMapper();

  DatasourceEvent fromSnapshot({
    required DatasourceEventType type,
    required DataSourceConnectionSnapshot snapshot,
    required AppSettings settings,
    required AnalysisSubject subject,
    required DateTime occurredAt,
    String? message,
  }) {
    return DatasourceEvent(
      type: type,
      occurredAt: occurredAt,
      payload: DatasourceEventPayload(
        sourceKind: snapshot.kind,
        sourceId: snapshot.kind.name,
        subjectId: subject.id,
        normalizedUrl: _url(settings, snapshot.kind),
        accessTokenFingerprint: null,
        configured: snapshot.configured,
        enabled: snapshot.active,
        reachable: snapshot.status == DataSourceConnectionStatus.detected ||
            snapshot.status == DataSourceConnectionStatus.connected ||
            snapshot.status == DataSourceConnectionStatus.syncing,
        message: message ?? snapshot.subtitle,
      ),
    );
  }

  String? _url(AppSettings settings, DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => settings.xdripBaseUrl,
      DataSourceKind.nightscout => settings.nightscoutBaseUrl,
    };
  }
}
