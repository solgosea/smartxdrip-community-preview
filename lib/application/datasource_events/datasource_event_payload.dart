import '../../domain/data_source/data_source_kind.dart';

class DatasourceEventPayload {
  final DataSourceKind sourceKind;
  final String sourceId;
  final String subjectId;
  final String? normalizedUrl;
  final String? accessTokenFingerprint;
  final bool configured;
  final bool enabled;
  final bool reachable;
  final String? message;

  const DatasourceEventPayload({
    required this.sourceKind,
    required this.sourceId,
    required this.subjectId,
    this.normalizedUrl,
    this.accessTokenFingerprint,
    required this.configured,
    required this.enabled,
    required this.reachable,
    this.message,
  });

  Map<String, Object?> toJson() {
    return {
      'sourceKind': sourceKind.name,
      'sourceId': sourceId,
      'subjectId': subjectId,
      'normalizedUrl': normalizedUrl,
      'accessTokenFingerprint': accessTokenFingerprint,
      'configured': configured,
      'enabled': enabled,
      'reachable': reachable,
      'message': message,
    };
  }
}
