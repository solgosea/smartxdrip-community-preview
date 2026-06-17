import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/home/application/home_metric_window_policy.dart';

void main() {
  test('home summary metrics use the 24h window', () {
    const policy = HomeMetricWindowPolicy();

    expect(policy.average.hours, 24);
    expect(policy.timeInRange.hours, 24);
    expect(policy.coefficientOfVariation.hours, 24);
    expect(policy.coefficientOfVariation.labelSuffix, '24h');
  });
}
