import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/application/text/episode_detail_text_renderer.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/text/episode_detail_text_slot.dart';
import 'package:smart_xdrip/plugins/explore/episode_detail/domain/text/episode_detail_text_type.dart';

void main() {
  test('episode detail renderer renders pattern text from facts', () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail('highPatternClustered'),
      facts: {
        'count': 5,
        'range': '07:40-09:15',
      },
    );

    expect(text, contains('5 morning-window high episodes'));
    expect(text, contains('07:40-09:15'));
  });

  test('episode detail renderer renders severity text from facts', () {
    const renderer = EpisodeDetailTextRenderer();

    final text = renderer.render(
      slot: EpisodeDetailTextSlot.detail,
      type: EpisodeDetailTextType.detail('lowSeverityDescription'),
      facts: {'nadirLabel': '3.1 mmol/L'},
    );

    expect(text, '3.1 mmol/L is compared with this threshold band.');
  });
}
