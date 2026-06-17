import 'package:flutter/material.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_event.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/text/history_episode_text_builder.dart';
import '../domain/history_episode_navigation_target.dart';
import '../domain/sections/history_episode_section.dart';
import '../models/history_view_model.dart';
import '../../explore/episode_detail/models/episode_kind.dart';

class HistoryEpisodeViewModelMapper {
  final HistoryEpisodeTextBuilder textBuilder;

  const HistoryEpisodeViewModelMapper({
    this.textBuilder = const HistoryEpisodeTextBuilder(),
  });

  List<HistoryEpisodeCalloutViewModel> map(
      HistoryEpisodeSection section, AppSettings settings,
      {required DateTime selectedDay}) {
    return [
      for (final context in section.episodes)
        _callout(context.event, settings, selectedDay),
    ];
  }

  HistoryEpisodeCalloutViewModel _callout(
    GlucoseEvent event,
    AppSettings settings,
    DateTime selectedDay,
  ) {
    final isHigh = event.type == GlucoseEventType.highEpisode;
    final target = HistoryEpisodeNavigationTarget(
      kind: isHigh ? EpisodeKind.high : EpisodeKind.low,
      eventTime: event.time,
      endTime: event.endTime,
      value: event.peakOrNadir ?? event.value,
      durationMinutes: event.durationMinutes,
      sourceDay: selectedDay,
    );
    return HistoryEpisodeCalloutViewModel(
      color: isHigh ? AppColors.rose : AppColors.blue,
      icon: isHigh ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
      label: isHigh ? 'High episode' : 'Low episode',
      summary: textBuilder.calloutSummary(event, settings),
      actionLabel: 'View episode analysis ->',
      route: target.route(),
      navigationTarget: target,
    );
  }
}
