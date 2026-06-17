import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/statistics/application/text/statistics_agp_text_builder.dart';

void main() {
  const renderer = StatisticsAgpTextBuilder();

  test('renders AGP empty state from the template catalog', () {
    expect(
      renderer.renderEmpty(),
      'Not enough CGM data yet to draw an AGP profile.',
    );
  });

  test('renders AGP summary facts through templates', () {
    expect(
      renderer.renderDawn({
        'dawnConsistent': true,
        'windowLabel': '04:00-07:00',
        'significantDays': 9,
        'observedDays': 12,
        'averageRise': '1.4',
        'glucoseUnit': 'mmol/L',
      }),
      contains('9 of 12 observed days'),
    );

    expect(
      renderer.renderPeak({
        'peakValue': '8.3',
        'glucoseUnit': 'mmol/L',
        'peakTime': '13:00',
      }),
      'The median curve peaks near 8.3 mmol/L around 13:00.',
    );

    expect(
      renderer.renderVariability({
        'topPeriod': 'Morning',
        'topCv': '34',
        'secondPeriod': 'afternoon',
        'secondCv': '28',
      }),
      'Morning is the most variable period by CV (34%), followed by afternoon (28%).',
    );
  });
}
