import 'package:smart_xdrip/application/plugin_text/plugin_text_template.dart';

import '../../domain/text/history_text_slot.dart';
import '../../domain/text/history_text_type.dart';

class HistoryDefaultTextTemplates {
  static const all = <PluginTextTemplate>[
    PluginTextTemplate(
      key: 'history.episodeCallout.v1',
      slot: HistoryTextSlot.episode,
      type: 'episode_callout',
      bodyTemplate:
          'at {time} - {value}, lasted {durationMinutes} min. {extraText}',
    ),
    PluginTextTemplate(
      key: 'history.episodeCalloutNoExtra.v1',
      slot: HistoryTextSlot.episode,
      type: 'episode_callout',
      bodyTemplate: 'at {time} - {value}, lasted {durationMinutes} min',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetail.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      bodyTemplate: '{rate} - {durationMinutes} min above {highThreshold}',
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailDurationOnly.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      bodyTemplate: '{durationMinutes} min above {highThreshold}',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailRateOnly.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      bodyTemplate: '{rate}',
      priority: 120,
    ),
    PluginTextTemplate(
      key: 'history.highEventDetailEmpty.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'high_event_detail',
      bodyTemplate: '',
      priority: 130,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetail.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      bodyTemplate: 'Nocturnal - {durationMinutes} min below {lowThreshold}',
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailDurationOnly.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      bodyTemplate: '{durationMinutes} min below {lowThreshold}',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailNocturnalOnly.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      bodyTemplate: 'Nocturnal',
      priority: 120,
    ),
    PluginTextTemplate(
      key: 'history.lowEventDetailEmpty.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'low_event_detail',
      bodyTemplate: '',
      priority: 130,
    ),
    PluginTextTemplate(
      key: 'history.recoveryDetail.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'recovery_detail',
      bodyTemplate: 'Back in range - {rate}',
    ),
    PluginTextTemplate(
      key: 'history.stableWindowDetail.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'stable_window_detail',
      bodyTemplate: 'Low variability window',
    ),
    PluginTextTemplate(
      key: 'history.firstReadingDetail.v1',
      slot: HistoryTextSlot.eventDetail,
      type: 'first_reading_detail',
      bodyTemplate: 'Fasting glucose',
    ),
    PluginTextTemplate(
      key: 'history.highValueSuffix.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      bodyTemplate: '{value} - peak',
    ),
    PluginTextTemplate(
      key: 'history.riseValueSuffix.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      bodyTemplate: '{value} - local peak',
      priority: 110,
    ),
    PluginTextTemplate(
      key: 'history.plainValueSuffix.v1',
      slot: HistoryTextSlot.value,
      type: 'value_suffix',
      bodyTemplate: '{value}',
      priority: 120,
    ),
  ];

  static String bodyFor(HistoryTextTemplate template) {
    return all
        .firstWhere((candidate) => candidate.key == template.key)
        .bodyTemplate;
  }

  const HistoryDefaultTextTemplates._();
}
