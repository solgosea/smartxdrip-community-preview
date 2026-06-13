import '../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../domain/entities/app_settings.dart';
import '../target_range_value_policy.dart';

class TargetRangeInputFormatter {
  final GlucoseUnitFormatService glucoseFormatter;
  final TargetRangeValuePolicy policy;

  const TargetRangeInputFormatter({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.policy = const TargetRangeValuePolicy(),
  });

  String unitLabel(GlucoseUnit unit) => glucoseFormatter.unitLabel(unit);

  String label(double mmol, GlucoseUnit unit) {
    return glucoseFormatter.value(mmol, unit).valueLabel;
  }

  double stepMmol(GlucoseUnit unit) {
    return policy.displayToMmol(
      switch (unit) {
        GlucoseUnit.mmolL => 0.1,
        GlucoseUnit.mgDl => 1,
      },
      unit,
    );
  }

  double parseDisplayToMmol(String raw, GlucoseUnit unit) {
    final value = double.tryParse(raw.trim());
    if (value == null) {
      throw const FormatException('Target range value must be numeric.');
    }
    return policy.displayToMmol(value, unit);
  }

  double snapMmol(double mmol, GlucoseUnit unit) {
    final display = policy.displayValue(mmol, unit);
    final snappedDisplay = switch (unit) {
      GlucoseUnit.mmolL => (display * 10).round() / 10,
      GlucoseUnit.mgDl => display.roundToDouble(),
    };
    return policy.displayToMmol(snappedDisplay, unit);
  }
}
