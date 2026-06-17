import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';
import 'episode_similar_bubble_chart.dart';
import 'episode_similar_selected_card.dart';

class EpisodeSimilarChartSection extends StatefulWidget {
  final EpisodeSimilarChartViewModel viewModel;
  final bool high;

  const EpisodeSimilarChartSection({
    super.key,
    required this.viewModel,
    required this.high,
  });

  @override
  State<EpisodeSimilarChartSection> createState() =>
      _EpisodeSimilarChartSectionState();
}

class _EpisodeSimilarChartSectionState
    extends State<EpisodeSimilarChartSection> {
  EpisodeSimilarChartPointViewModel? _selectedPoint;

  EpisodeSimilarSelectionViewModel? get _selection {
    final selectedPoint = _selectedPoint;
    if (selectedPoint == null) return widget.viewModel.selected;
    return EpisodeSimilarSelectionViewModel(
      dateLabel: 'Selected · ${selectedPoint.dateLabel}',
      title:
          '${selectedPoint.timeLabel} · ${widget.high ? 'high' : 'low'} episode',
      description: selectedPoint.isCurrent
          ? 'This is the current episode. Slide to compare it with similar episodes.'
          : 'Selected from the 30-day similarity chart.',
      matchLabel:
          selectedPoint.isCurrent ? 'Current' : selectedPoint.matchLabel,
      valueText: selectedPoint.valueText,
      durationText: selectedPoint.durationText,
      recoveryText: selectedPoint.slowOrUnknownRecovery ? 'Review' : 'Visible',
      badgeColor: selectedPoint.color,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _SimilarColors.forKind(widget.high);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EpisodeSectionLabel(
          index: widget.high ? '08' : '09',
          title: widget.viewModel.title,
          trailing: widget.viewModel.trailing,
          accent: colors.accent,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.card,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.border),
          ),
          child: widget.viewModel.hasMatches
              ? _ChartContent(
                  viewModel: widget.viewModel,
                  selection: _selection,
                  colors: colors,
                  onSelected: (point) => setState(() => _selectedPoint = point),
                )
              : Text(
                  widget.viewModel.emptyText,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: colors.muted,
                    height: 1.4,
                  ),
                ),
        ),
      ],
    );
  }
}

class _ChartContent extends StatelessWidget {
  final EpisodeSimilarChartViewModel viewModel;
  final EpisodeSimilarSelectionViewModel? selection;
  final _SimilarColors colors;
  final ValueChanged<EpisodeSimilarChartPointViewModel> onSelected;

  const _ChartContent({
    required this.viewModel,
    required this.selection,
    required this.colors,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 7,
          runSpacing: 7,
          children: [
            for (final chip in viewModel.chips)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
                decoration: BoxDecoration(
                  color: colors.panel,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: colors.border),
                ),
                child: Text(
                  chip,
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: colors.soft,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        EpisodeSimilarBubbleChart(
          points: viewModel.points,
          valueAxisLabel: viewModel.valueAxisLabel,
          panelColor: colors.panel,
          gridColor: colors.border,
          textColor: colors.text,
          mutedColor: colors.muted,
          readoutBorderColor: colors.accent.withOpacity(0.36),
          onSelected: onSelected,
        ),
        if (selection != null)
          EpisodeSimilarSelectedCard(
            selection: selection!,
            panelColor: colors.panel,
            borderColor: colors.border,
            textColor: colors.text,
            softColor: colors.soft,
            mutedColor: colors.muted,
          ),
        const SizedBox(height: 10),
        Text(
          viewModel.note,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            height: 1.48,
            color: colors.soft,
          ),
        ),
      ],
    );
  }
}

class _SimilarColors {
  final Color card;
  final Color panel;
  final Color border;
  final Color text;
  final Color soft;
  final Color muted;
  final Color accent;

  const _SimilarColors({
    required this.card,
    required this.panel,
    required this.border,
    required this.text,
    required this.soft,
    required this.muted,
    required this.accent,
  });

  factory _SimilarColors.forKind(bool high) {
    if (high) {
      return const _SimilarColors(
        card: AppColors.bgCard,
        panel: AppColors.bgCard2,
        border: AppColors.border,
        text: AppColors.text,
        soft: AppColors.textSoft,
        muted: AppColors.textDim,
        accent: AppColors.rose,
      );
    }
    return const _SimilarColors(
      card: LowEpisodeStyle.panel,
      panel: LowEpisodeStyle.panel2,
      border: LowEpisodeStyle.line,
      text: LowEpisodeStyle.text,
      soft: LowEpisodeStyle.soft,
      muted: LowEpisodeStyle.muted,
      accent: LowEpisodeStyle.blue,
    );
  }
}
