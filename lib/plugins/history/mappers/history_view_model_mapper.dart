import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../domain/entities/app_settings.dart';
import '../../../domain/entities/glucose_reading.dart';
import '../../../foundation/theme/app_colors.dart';
import '../application/text/history_filter_text_builder.dart';
import '../domain/sections/history_date_section.dart';
import '../domain/sections/history_stats_section.dart';
import '../domain/sections/history_summary_section.dart';
import '../engine/history_engine_output.dart';
import '../models/history_view_model.dart';
import 'history_curve_view_model_mapper.dart';
import 'history_episode_view_model_mapper.dart';
import 'history_events_view_model_mapper.dart';

class HistoryViewModelMapper {
  final GlucoseUnitFormatService glucoseFormatter;
  final HistoryCurveViewModelMapper curveMapper;
  final HistoryEpisodeViewModelMapper episodeMapper;
  final HistoryEventsViewModelMapper eventsMapper;
  final HistoryFilterTextBuilder filterTextBuilder;

  const HistoryViewModelMapper({
    this.glucoseFormatter = const GlucoseUnitFormatService(),
    this.curveMapper = const HistoryCurveViewModelMapper(),
    this.episodeMapper = const HistoryEpisodeViewModelMapper(),
    this.eventsMapper = const HistoryEventsViewModelMapper(),
    this.filterTextBuilder = const HistoryFilterTextBuilder(),
  });

  HistoryViewModel map(HistoryEngineOutput output) {
    final filterLabel = filterTextBuilder.label(output.timeFilter);
    return HistoryViewModel(
      dateNav: _dateNav(output.dateSection),
      summaryChips: _summaryChips(output.summarySection, output.settings),
      curve: curveMapper.map(output.curveSection, output.settings),
      stats: _stats(output.statsSection, output.settings),
      episodeCallouts: episodeMapper.map(
        output.episodeSection,
        output.settings,
        selectedDay: output.dateSection.selectedDay,
      ),
      events: eventsMapper.map(output.eventsSection, output.settings),
      timeFilter: filterLabel == null
          ? null
          : HistoryTimeFilterViewModel(label: filterLabel),
    );
  }

  HistoryDateNavViewModel _dateNav(HistoryDateSection section) {
    final yearLabel = DateFormat('y').format(section.selectedDay);
    return HistoryDateNavViewModel(
      dateLabel: DateFormat('EEEE, MMM d').format(section.selectedDay),
      subtitle: section.isToday
          ? '$yearLabel - DAY VIEW  -  TODAY'
          : '$yearLabel - DAY VIEW',
      isToday: section.isToday,
    );
  }

  List<HistorySummaryChipViewModel> _summaryChips(
    HistorySummarySection section,
    AppSettings settings,
  ) {
    final tir = section.tir;
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(section.readings);
    final peakLabel = glucoseFormatter.value(peak, unit).valueLabel;
    final meanLabel = glucoseFormatter.value(tir.mean, unit).valueLabel;
    return [
      HistorySummaryChipViewModel(
        text: 'TIR ${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistorySummaryChipViewModel(
        text: 'Peak $peakLabel',
        color:
            peak > settings.highThreshold ? AppColors.amber : AppColors.green,
      ),
      HistorySummaryChipViewModel(
        text: 'CV ${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
      HistorySummaryChipViewModel(
        text: 'Avg $meanLabel',
        color: (tir.mean >= settings.lowThreshold &&
                tir.mean <= settings.highThreshold)
            ? AppColors.green
            : AppColors.amber,
      ),
    ];
  }

  List<HistoryStatCardViewModel> _stats(
    HistoryStatsSection section,
    AppSettings settings,
  ) {
    final tir = section.tir;
    if (tir == null) return const [];
    final unit = settings.unit;
    final peak = _peak(section.readings);
    final mean = glucoseFormatter.value(tir.mean, unit);
    final peakDisplay = glucoseFormatter.value(peak, unit);
    return [
      HistoryStatCardViewModel(
        label: 'TIR',
        value: '${tir.tir.toStringAsFixed(0)}%',
        color: _tirColor(tir.tir),
      ),
      HistoryStatCardViewModel(
        label: 'AVG',
        value: mean.valueLabel,
        unit: mean.unitLabel,
        color: AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: 'PEAK',
        value: peakDisplay.valueLabel,
        unit: peakDisplay.unitLabel,
        color: peak > settings.highThreshold ? AppColors.amber : AppColors.text,
      ),
      HistoryStatCardViewModel(
        label: 'CV',
        value: '${tir.cv.toStringAsFixed(0)}%',
        color: tir.cv < 36 ? AppColors.green : AppColors.amber,
      ),
    ];
  }

  Color _tirColor(double tir) {
    if (tir >= 70) return AppColors.green;
    if (tir >= 50) return AppColors.amber;
    return AppColors.rose;
  }

  double _peak(List<GlucoseReading> readings) {
    if (readings.isEmpty) return 0;
    return readings.map((reading) => reading.value).reduce(
          (a, b) => a > b ? a : b,
        );
  }
}
