import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_band.dart';
import 'package:smart_xdrip/domain/glucose_trend/glucose_trend_visual_mapper.dart';

void main() {
  group('GlucoseTrendVisualMapper', () {
    test('maps rates to visual arrows and labels', () {
      const mapper = GlucoseTrendVisualMapper();

      expect(mapper.map(null).arrow, '--');
      expect(mapper.map(null).band, GlucoseTrendBand.unknown);

      expect(mapper.map(0.18).arrow, '\u2191\u2191');
      expect(mapper.map(0.18).label, 'Rising fast');
      expect(mapper.map(0.08).arrow, '\u2191');
      expect(mapper.map(0.01).arrow, '\u2192');
      expect(mapper.map(-0.08).arrow, '\u2193');
      expect(mapper.map(-0.18).arrow, '\u2193\u2193');
      expect(mapper.map(-0.18).label, 'Falling fast');
    });
  });
}
