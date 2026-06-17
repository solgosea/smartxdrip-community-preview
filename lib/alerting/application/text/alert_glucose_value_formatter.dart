import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../domain/entities/app_settings.dart';

class AlertGlucoseValueFormatter {
  final GlucoseUnitFormatService formatter;

  const AlertGlucoseValueFormatter({
    this.formatter = const GlucoseUnitFormatService(),
  });

  String value(double mmol, GlucoseUnit unit) {
    return formatter.value(mmol, unit).fullLabel;
  }

  String rate(double mmolPerMin, GlucoseUnit unit) {
    return formatter.rate(mmolPerMin, unit).fullLabel;
  }
}
