import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/presentation/common/navigation/safe_navigation.dart';
import '../shared/episode_chart_card.dart';
import '../shared/episode_disclaimer.dart';
import '../shared/episode_header.dart';

import 'high_burden/high_episode_burden_card.dart';
import 'high_context/high_episode_context_card.dart';
import 'high_driver/high_episode_driver_card.dart';
import 'high_lifecycle/high_episode_lifecycle_card.dart';
import 'high_reliability/high_episode_reliability_card.dart';
import 'high_repeat/high_episode_repeat_card.dart';
import 'high_summary/high_episode_summary_card.dart';
import 'low_burden/low_episode_burden_card.dart';
import 'low_context/low_episode_context_card.dart';
import 'low_driver/low_episode_driver_card.dart';
import 'low_lifecycle/low_episode_lifecycle_card.dart';
import 'low_recovery/low_episode_recovery_card.dart';
import 'low_reliability/low_episode_reliability_card.dart';
import 'low_repeat/low_episode_repeat_card.dart';
import 'low_summary/low_episode_summary_card.dart';
import 'low_shared/low_episode_style.dart';
import 'similar/episode_similar_chart_section.dart';
import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';
import 'episode_empty_state.dart';
import 'shared/episode_section_label.dart';

class EpisodeDetailBody extends StatelessWidget {
  final EpisodeDetailViewModel viewModel;
  final bool showResetToLatest;
  final VoidCallback? onResetToLatest;

  const EpisodeDetailBody({
    super.key,
    required this.viewModel,
    this.showResetToLatest = false,
    this.onResetToLatest,
  });

  @override
  Widget build(BuildContext context) {
    if (!viewModel.hasEpisode) {
      return EpisodeEmptyState(viewModel: viewModel);
    }

    final chart = viewModel.chart!;
    final themeColor =
        viewModel.kind == EpisodeKind.high ? AppColors.rose : AppColors.blue;

    if (viewModel.kind == EpisodeKind.high) {
      return _HighEpisodeDetailScaffold(
        viewModel: viewModel,
        chart: chart,
        themeColor: themeColor,
        showResetToLatest: showResetToLatest,
        onResetToLatest: onResetToLatest,
      );
    }

    return _LowEpisodeDetailScaffold(
      viewModel: viewModel,
      chart: chart,
      showResetToLatest: showResetToLatest,
      onResetToLatest: onResetToLatest,
    );
  }
}

class _HighEpisodeDetailScaffold extends StatelessWidget {
  final EpisodeDetailViewModel viewModel;
  final EpisodeChartViewModel chart;
  final Color themeColor;
  final bool showResetToLatest;
  final VoidCallback? onResetToLatest;

  const _HighEpisodeDetailScaffold({
    required this.viewModel,
    required this.chart,
    required this.themeColor,
    required this.showResetToLatest,
    required this.onResetToLatest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EpisodeHeader(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                onBack: () => context.safePopOrHome(),
                trailing: showResetToLatest
                    ? _ResetToLatestButton(
                        color: AppColors.rose,
                        onTap: onResetToLatest,
                      )
                    : null,
              ),
              if (viewModel.highSummary != null)
                HighEpisodeSummaryCard(viewModel: viewModel.highSummary!),
              if (viewModel.highBurden != null)
                HighEpisodeBurdenCard(viewModel: viewModel.highBurden!),
              if (viewModel.highLifecycle != null)
                HighEpisodeLifecycleCard(viewModel: viewModel.highLifecycle!),
              const EpisodeSectionLabel(index: '04', title: 'Episode chart'),
              EpisodeChartCard(
                readings: chart.readings,
                unit: chart.unit,
                lowThreshold: chart.lowThreshold,
                highThreshold: chart.highThreshold,
                onsetTime: chart.onsetTime,
                peakOrNadirTime: chart.peakOrNadirTime,
                recoveryTime: chart.recoveryTime,
                timeRangeStart: chart.timeRangeStart,
                timeRangeEnd: chart.timeRangeEnd,
                themeColor: chart.themeColor,
                episode: chart.episode,
              ),
              if (viewModel.highDriver != null)
                HighEpisodeDriverCard(viewModel: viewModel.highDriver!),
              if (viewModel.highContext != null)
                HighEpisodeContextCard(viewModel: viewModel.highContext!),
              if (viewModel.highRepeat != null)
                HighEpisodeRepeatCard(viewModel: viewModel.highRepeat!),
              if (viewModel.similarChart != null)
                EpisodeSimilarChartSection(
                  viewModel: viewModel.similarChart!,
                  high: true,
                ),
              if (viewModel.highReliability != null)
                HighEpisodeReliabilityCard(
                  viewModel: viewModel.highReliability!,
                ),
              EpisodeDisclaimer(text: viewModel.disclaimer),
            ],
          ),
        ),
      ),
    );
  }
}

class _LowEpisodeDetailScaffold extends StatelessWidget {
  final EpisodeDetailViewModel viewModel;
  final EpisodeChartViewModel chart;
  final bool showResetToLatest;
  final VoidCallback? onResetToLatest;

  const _LowEpisodeDetailScaffold({
    required this.viewModel,
    required this.chart,
    required this.showResetToLatest,
    required this.onResetToLatest,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LowEpisodeStyle.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              EpisodeHeader(
                title: viewModel.title,
                subtitle: viewModel.subtitle,
                onBack: () => context.safePopOrHome(),
                trailing: showResetToLatest
                    ? _ResetToLatestButton(
                        color: LowEpisodeStyle.blue,
                        onTap: onResetToLatest,
                      )
                    : null,
              ),
              EpisodeSectionLabel(
                index: '01',
                title: 'Episode summary',
                trailing: viewModel.statusTime,
                accent: LowEpisodeStyle.blue,
              ),
              if (viewModel.lowSummary != null)
                LowEpisodeSummaryCard(viewModel: viewModel.lowSummary!),
              if (viewModel.lowBurden != null)
                LowEpisodeBurdenCard(viewModel: viewModel.lowBurden!),
              if (viewModel.lowLifecycle != null)
                LowEpisodeLifecycleCard(viewModel: viewModel.lowLifecycle!),
              const EpisodeSectionLabel(
                index: '04',
                title: 'Episode chart',
                accent: LowEpisodeStyle.blue,
              ),
              EpisodeChartCard(
                readings: chart.readings,
                unit: chart.unit,
                lowThreshold: chart.lowThreshold,
                highThreshold: chart.highThreshold,
                onsetTime: chart.onsetTime,
                peakOrNadirTime: chart.peakOrNadirTime,
                recoveryTime: chart.recoveryTime,
                timeRangeStart: chart.timeRangeStart,
                timeRangeEnd: chart.timeRangeEnd,
                themeColor: chart.themeColor,
                episode: chart.episode,
              ),
              if (viewModel.lowDriver != null)
                LowEpisodeDriverCard(viewModel: viewModel.lowDriver!),
              if (viewModel.lowRecovery != null)
                LowEpisodeRecoveryCard(viewModel: viewModel.lowRecovery!),
              if (viewModel.lowContext != null)
                LowEpisodeContextCard(viewModel: viewModel.lowContext!),
              if (viewModel.lowRepeat != null)
                LowEpisodeRepeatCard(viewModel: viewModel.lowRepeat!),
              if (viewModel.similarChart != null)
                EpisodeSimilarChartSection(
                  viewModel: viewModel.similarChart!,
                  high: false,
                ),
              if (viewModel.lowReliability != null)
                LowEpisodeReliabilityCard(
                  viewModel: viewModel.lowReliability!,
                ),
              EpisodeDisclaimer(
                text: viewModel.disclaimer,
                card: true,
                color: LowEpisodeStyle.muted,
                backgroundColor: LowEpisodeStyle.blue.withOpacity(0.065),
                borderColor: LowEpisodeStyle.lineStrong,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResetToLatestButton extends StatelessWidget {
  final Color color;
  final VoidCallback? onTap;

  const _ResetToLatestButton({
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'Back to latest episode',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.34)),
          ),
          child: Icon(
            Icons.refresh_rounded,
            size: 18,
            color: color,
          ),
        ),
      ),
    );
  }
}
