import 'package:flutter/material.dart';

class EpisodeRepeatSummaryTiles extends StatelessWidget {
  final String summaryStat;
  final String summaryLabel;
  final String clusterTitle;
  final String clusterBody;
  final Color panelColor;
  final Color borderColor;
  final Color accentColor;
  final Color textColor;
  final Color softColor;
  final Color mutedColor;

  const EpisodeRepeatSummaryTiles({
    super.key,
    required this.summaryStat,
    required this.summaryLabel,
    required this.clusterTitle,
    required this.clusterBody,
    required this.panelColor,
    required this.borderColor,
    required this.accentColor,
    required this.textColor,
    required this.softColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 310;
        final children = [
          _CountTile(
            summaryStat: summaryStat,
            summaryLabel: summaryLabel,
            panelColor: panelColor,
            borderColor: borderColor,
            accentColor: accentColor,
            mutedColor: mutedColor,
          ),
          _CopyTile(
            title: clusterTitle,
            body: clusterBody,
            panelColor: panelColor,
            borderColor: borderColor,
            textColor: textColor,
            softColor: softColor,
          ),
        ];
        if (compact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              children[0],
              const SizedBox(height: 8),
              children[1],
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 11, child: children[0]),
            const SizedBox(width: 10),
            Expanded(flex: 9, child: children[1]),
          ],
        );
      },
    );
  }
}

class _CountTile extends StatelessWidget {
  final String summaryStat;
  final String summaryLabel;
  final Color panelColor;
  final Color borderColor;
  final Color accentColor;
  final Color mutedColor;

  const _CountTile({
    required this.summaryStat,
    required this.summaryLabel,
    required this.panelColor,
    required this.borderColor,
    required this.accentColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            summaryStat,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 30,
              fontWeight: FontWeight.w900,
              height: 1,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            summaryLabel,
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontSize: 8,
              color: mutedColor,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyTile extends StatelessWidget {
  final String title;
  final String body;
  final Color panelColor;
  final Color borderColor;
  final Color textColor;
  final Color softColor;

  const _CopyTile({
    required this.title,
    required this.body,
    required this.panelColor,
    required this.borderColor,
    required this.textColor,
    required this.softColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: textColor,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            body,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              height: 1.45,
              color: softColor,
            ),
          ),
        ],
      ),
    );
  }
}
