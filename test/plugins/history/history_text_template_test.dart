import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/history/application/text/history_text_renderer.dart';

void main() {
  test('history text renderer renders episode callout from structured facts',
      () {
    const renderer = HistoryTextRenderer();

    final text = renderer.render(HistoryTextTemplate.episodeCallout, {
      'time': '03:20',
      'value': '3.1 mmol/L',
      'durationMinutes': 23,
      'extraText': 'Nocturnal low, rate -0.18 mmol/L/min',
    });

    expect(text, contains('03:20'));
    expect(text, contains('3.1 mmol/L'));
    expect(text, contains('23 min'));
    expect(text, contains('Nocturnal low'));
  });

  test('history text renderer renders high event detail variants', () {
    const renderer = HistoryTextRenderer();

    final text = renderer.render(HistoryTextTemplate.highEventDetail, {
      'rate': '+0.10 mmol/L/min',
      'durationMinutes': 38,
      'highThreshold': '10.0',
    });

    expect(text, '+0.10 mmol/L/min - 38 min above 10.0');
  });
}
