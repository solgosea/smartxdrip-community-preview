import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/profile/target_range/profile_section/target_range_profile_view_model_mapper.dart';

void main() {
  test('maps target range into four profile rows', () {
    const settings = AppSettings(
      unit: GlucoseUnit.mmolL,
      lowThreshold: 3.9,
      highThreshold: 10.0,
      veryHighThreshold: 13.9,
    );

    final viewModel = const TargetRangeProfileViewModelMapper().map(settings);

    expect(viewModel.ranges.map((row) => row.label), [
      'Target range',
      'Low threshold',
      'High threshold',
      'Very high threshold',
    ]);
    expect(viewModel.ranges.first.valueLabel, '3.9-10.0 mmol/L');
  });
}
