import '../../domain/text/insights_text_slot.dart';
import '../../domain/text/insights_text_type.dart';
import 'insights_text_renderer.dart';

class InsightsHeaderTextBuilder {
  final InsightsTextRenderer renderer;

  const InsightsHeaderTextBuilder({
    this.renderer = const InsightsTextRenderer(),
  });

  String date(DateTime value) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return renderer.render(
      slot: InsightsTextSlot.headerDate,
      type: InsightsTextType.defaultText,
      facts: {
        'month': months[value.month],
        'day': value.day,
        'year': value.year,
      },
    );
  }
}
