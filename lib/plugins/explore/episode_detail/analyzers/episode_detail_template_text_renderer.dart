import 'package:smart_xdrip/application/insight/template_renderer.dart';

enum EpisodeDetailTextTemplate {
  highDisclaimer,
  lowDisclaimer,
  highEmpty,
  lowEmpty,
  baselineUnavailable,
  highBaseline,
  lowBaseline,
  slopeUnavailable,
  highSlopeNoComparison,
  lowSlopeNoComparison,
  highSlopeComparison,
  lowSlopeComparison,
  variabilityUnavailable,
  variabilityAvailable,
  highPatternEmpty,
  highPatternClustered,
  highPatternNoCluster,
  lowPatternEmpty,
  lowPatternClustered,
  lowPatternNoCluster,
  lowDistribution,
  lowSeverityDescription,
  lowSeverityFootnote,
}

class EpisodeDetailTemplateTextRenderer {
  final TemplateRenderer renderer;

  const EpisodeDetailTemplateTextRenderer({
    this.renderer = const TemplateRenderer(),
  });

  String render(
    EpisodeDetailTextTemplate template,
    Map<String, Object?> facts,
  ) {
    return renderer.render(_templates[template]!, facts);
  }

  static const _templates = <EpisodeDetailTextTemplate, String>{
    EpisodeDetailTextTemplate.highDisclaimer:
        'This is observational CGM analysis only and is not medical advice. Consult your healthcare provider for clinical decisions.',
    EpisodeDetailTextTemplate.lowDisclaimer:
        'Low glucose episodes require clinical interpretation. This is observational CGM analysis only and is not medical advice.',
    EpisodeDetailTextTemplate.highEmpty:
        'No high glucose episodes detected in the last 30 days.',
    EpisodeDetailTextTemplate.lowEmpty:
        'No low glucose episodes detected in the last 30 days.',
    EpisodeDetailTextTemplate.baselineUnavailable:
        'Baseline range unavailable; not enough readings before onset',
    EpisodeDetailTextTemplate.highBaseline: 'Pre-onset baseline {range}',
    EpisodeDetailTextTemplate.lowBaseline: 'Pre-episode range {range}',
    EpisodeDetailTextTemplate.slopeUnavailable:
        'Lead-up readings limited; slope cannot be estimated from this window',
    EpisodeDetailTextTemplate.highSlopeNoComparison:
        'Lead-up rise {slope}; historical comparison unavailable',
    EpisodeDetailTextTemplate.lowSlopeNoComparison:
        'Lead-up descent {slope}; historical comparison unavailable',
    EpisodeDetailTextTemplate.highSlopeComparison:
        'Lead-up rise {slope}; {direction} historical window average ({typicalSlope})',
    EpisodeDetailTextTemplate.lowSlopeComparison:
        'Lead-up descent {slope}; {direction} historical window average ({typicalSlope})',
    EpisodeDetailTextTemplate.variabilityUnavailable:
        'Time-window variability unavailable; not enough historical readings',
    EpisodeDetailTextTemplate.variabilityAvailable:
        '{label} window ({windowText}) CV {cv}%, rank {rank}/{total} by variability',
    EpisodeDetailTextTemplate.highPatternEmpty:
        'No morning-window high episodes were detected in the 14-day analysis window.',
    EpisodeDetailTextTemplate.highPatternClustered:
        '{count} morning-window high episodes were detected in the last 14 days. Events occurred between {range}.',
    EpisodeDetailTextTemplate.highPatternNoCluster:
        '{count} morning-window high episodes were detected in the last 14 days. The time cluster cannot be estimated from the current sample.',
    EpisodeDetailTextTemplate.lowPatternEmpty:
        'No nocturnal low episodes were detected in the 30-day analysis window.',
    EpisodeDetailTextTemplate.lowPatternClustered:
        '{count} nocturnal low episodes were detected in the past 30 days. They occurred between {range}.',
    EpisodeDetailTextTemplate.lowPatternNoCluster:
        '{count} nocturnal low episodes were detected in the past 30 days. The time cluster cannot be estimated from the current sample.',
    EpisodeDetailTextTemplate.lowDistribution:
        'Low episode distribution: {nocturnalPct}% nocturnal (00:00-06:00) | {afternoonPct}% afternoon | {otherPct}% other',
    EpisodeDetailTextTemplate.lowSeverityDescription:
        '{nadirLabel} is compared with this threshold band.',
    EpisodeDetailTextTemplate.lowSeverityFootnote:
        'Severity is derived from the episode nadir value in the current CGM event.',
  };
}
