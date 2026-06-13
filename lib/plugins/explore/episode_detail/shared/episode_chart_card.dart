import 'package:flutter/material.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../domain/entities/glucose_reading.dart';
import '../../../../presentation/common/widgets/charts/glucose_line_chart.dart';

/// Card wrapping the GlucoseLineChart for an episode page.
class EpisodeChartCard extends StatefulWidget {
  final List<GlucoseReading> readings;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final DateTime onsetTime;
  final DateTime peakOrNadirTime;
  final DateTime? recoveryTime;
  final DateTime timeRangeStart;
  final DateTime timeRangeEnd;
  final Color themeColor; // rose for high, blue for low
  final ChartEpisode? episode; // tinted segment for the episode duration

  const EpisodeChartCard({
    super.key,
    required this.readings,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.onsetTime,
    required this.peakOrNadirTime,
    required this.timeRangeStart,
    required this.timeRangeEnd,
    required this.themeColor,
    this.recoveryTime,
    this.episode,
  });

  @override
  State<EpisodeChartCard> createState() => _EpisodeChartCardState();
}

class _EpisodeChartCardState extends State<EpisodeChartCard> {
  bool _inspecting = false;

  @override
  Widget build(BuildContext context) {
    final markers = <ChartEventMarker>[
      ChartEventMarker(time: widget.onsetTime, color: AppColors.amber),
      ChartEventMarker(time: widget.peakOrNadirTime, color: widget.themeColor),
      if (widget.recoveryTime != null)
        ChartEventMarker(time: widget.recoveryTime!, color: AppColors.green),
    ];

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: _inspecting ? 0.48 : 1,
            duration: const Duration(milliseconds: 140),
            child: const Text(
              'EPISODE TIMELINE',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: AppColors.textDim,
                letterSpacing: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 10),
          GlucoseLineChart(
            readings: widget.readings,
            unit: widget.unit,
            low: widget.lowThreshold,
            high: widget.highThreshold,
            timeRangeStart: widget.timeRangeStart,
            timeRangeEnd: widget.timeRangeEnd,
            height: 180,
            showCurrentDot: false,
            enableInspection: true,
            onInspectionChanged: (value) {
              if (!mounted || _inspecting == value) return;
              setState(() => _inspecting = value);
            },
            thresholdLineMode: ThresholdLineMode.colored,
            showMidYLabel: true,
            episodes: widget.episode != null ? [widget.episode!] : const [],
            markers: markers,
            coloringMode: ChartColoringMode.byEpisode,
          ),
        ],
      ),
    );
  }
}
