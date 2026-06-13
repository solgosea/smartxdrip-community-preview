import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/analyzers/episode_detail_template_text_renderer.dart';

void main() {
  test('episode detail renderer renders pattern text from facts', () {
    const renderer = EpisodeDetailTemplateTextRenderer();

    final text = renderer.render(
      EpisodeDetailTextTemplate.highPatternClustered,
      {
        'count': 5,
        'range': '07:40-09:15',
      },
    );

    expect(text, contains('5 morning-window high episodes'));
    expect(text, contains('07:40-09:15'));
  });

  test('episode detail renderer renders severity text from facts', () {
    const renderer = EpisodeDetailTemplateTextRenderer();

    final text = renderer.render(
      EpisodeDetailTextTemplate.lowSeverityDescription,
      {'nadirLabel': '3.1 mmol/L'},
    );

    expect(text, '3.1 mmol/L is compared with this threshold band.');
  });
}
