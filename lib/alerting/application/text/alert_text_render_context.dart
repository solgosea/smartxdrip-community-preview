import 'dart:ui';

import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../domain/entities/app_settings.dart';
import '../../domain/event/alert_event_source.dart';

class AlertTextRenderContext {
  final GlucoseUnit unit;
  final GlucoseUnitFormatService glucoseFormatter;
  final String? subjectDisplayName;
  final AlertEventSource? source;
  final Locale? locale;

  const AlertTextRenderContext({
    required this.unit,
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.subjectDisplayName,
    this.source,
    this.locale,
  });
}
