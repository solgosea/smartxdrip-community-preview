import 'package:smart_xdrip/application/insight/template_renderer.dart';

enum HistoryTextTemplate {
  episodeCallout,
  episodeCalloutNoExtra,
  highEventDetail,
  highEventDetailDurationOnly,
  highEventDetailRateOnly,
  highEventDetailEmpty,
  lowEventDetail,
  lowEventDetailDurationOnly,
  lowEventDetailNocturnalOnly,
  lowEventDetailEmpty,
  recoveryDetail,
  stableWindowDetail,
  firstReadingDetail,
  highValueSuffix,
  riseValueSuffix,
  plainValueSuffix,
}

class HistoryTemplateTextRenderer {
  final TemplateRenderer renderer;

  const HistoryTemplateTextRenderer({
    this.renderer = const TemplateRenderer(),
  });

  String render(
    HistoryTextTemplate template,
    Map<String, Object?> facts,
  ) {
    return renderer.render(_templates[template]!, facts);
  }

  static const _templates = <HistoryTextTemplate, String>{
    HistoryTextTemplate.episodeCallout:
        'at {time} - {value}, lasted {durationMinutes} min. {extraText}',
    HistoryTextTemplate.episodeCalloutNoExtra:
        'at {time} - {value}, lasted {durationMinutes} min',
    HistoryTextTemplate.highEventDetail:
        '{rate} - {durationMinutes} min above {highThreshold}',
    HistoryTextTemplate.highEventDetailDurationOnly:
        '{durationMinutes} min above {highThreshold}',
    HistoryTextTemplate.highEventDetailRateOnly: '{rate}',
    HistoryTextTemplate.highEventDetailEmpty: '',
    HistoryTextTemplate.lowEventDetail:
        'Nocturnal - {durationMinutes} min below {lowThreshold}',
    HistoryTextTemplate.lowEventDetailDurationOnly:
        '{durationMinutes} min below {lowThreshold}',
    HistoryTextTemplate.lowEventDetailNocturnalOnly: 'Nocturnal',
    HistoryTextTemplate.lowEventDetailEmpty: '',
    HistoryTextTemplate.recoveryDetail: 'Back in range - {rate}',
    HistoryTextTemplate.stableWindowDetail: 'Low variability window',
    HistoryTextTemplate.firstReadingDetail: 'Fasting glucose',
    HistoryTextTemplate.highValueSuffix: '{value} - peak',
    HistoryTextTemplate.riseValueSuffix: '{value} - local peak',
    HistoryTextTemplate.plainValueSuffix: '{value}',
  };
}
