import 'package:flutter/material.dart';

import '../../models/episode_detail_view_model.dart';
import '../low_shared/low_episode_style.dart';
import '../shared/episode_section_label.dart';

class LowEpisodeDriverCard extends StatelessWidget {
  final LowEpisodeDriverViewModel viewModel;

  const LowEpisodeDriverCard({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    final bars = [
      ('Nadir', viewModel.nadirScore),
      ('Duration', viewModel.durationScore),
      ('Descent', viewModel.descentScore),
      ('Recovery', viewModel.recoveryScore),
      ('Night', viewModel.nocturnalScore),
      ('Repeat', viewModel.repeatScore),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const EpisodeSectionLabel(
          index: '05',
          title: 'Main driver',
          trailing: 'Why review',
          accent: LowEpisodeStyle.blue,
        ),
        EpisodeSectionCard(
          color: LowEpisodeStyle.panel,
          borderColor: LowEpisodeStyle.line,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                viewModel.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: LowEpisodeStyle.text,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                viewModel.body,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  color: LowEpisodeStyle.soft,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              for (final item in bars)
                _DriverBar(label: item.$1, value: item.$2),
            ],
          ),
        ),
      ],
    );
  }
}

class _DriverBar extends StatelessWidget {
  final String label;
  final double value;

  const _DriverBar({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0, 1).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 74,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 10,
                color: LowEpisodeStyle.muted,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                minHeight: 7,
                value: clamped,
                backgroundColor: LowEpisodeStyle.panel2,
                valueColor: const AlwaysStoppedAnimation(LowEpisodeStyle.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
