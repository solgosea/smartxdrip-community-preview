import 'package:flutter/material.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';

import '../models/statistics_view_model.dart';
import 'statistics_section_card.dart';

class StatisticsHeatmapCard extends StatefulWidget {
  final StatisticsHeatmapViewModel viewModel;

  const StatisticsHeatmapCard({
    super.key,
    required this.viewModel,
  });

  @override
  State<StatisticsHeatmapCard> createState() => _StatisticsHeatmapCardState();
}

class _StatisticsHeatmapCardState extends State<StatisticsHeatmapCard> {
  int? _activeHour;
  double _readoutCenterX = 0;

  bool get _inspecting => _activeHour != null;

  @override
  void didUpdateWidget(covariant StatisticsHeatmapCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel.cells != widget.viewModel.cells) {
      _activeHour = null;
      _readoutCenterX = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatisticsSectionCard(
      title: widget.viewModel.title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeatmapScrubArea(
            cells: widget.viewModel.cells,
            activeHour: _activeHour,
            readoutCenterX: _readoutCenterX,
            inspecting: _inspecting,
            onScrub: _handleScrub,
            onEnd: _endScrub,
          ),
          const SizedBox(height: 7),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in widget.viewModel.labels) _HeatmapLabel(label),
            ],
          ),
        ],
      ),
    );
  }

  void _handleScrub(Offset localPosition, double width) {
    final cells = widget.viewModel.cells;
    if (cells.isEmpty || width <= 0) return;
    final cellWidth = width / cells.length;
    final hour = (localPosition.dx / cellWidth)
        .floor()
        .clamp(0, cells.length - 1)
        .toInt();
    final center = (hour + 0.5) * cellWidth;
    setState(() {
      _activeHour = hour;
      _readoutCenterX = center.clamp(40.0, width - 40.0).toDouble();
    });
  }

  void _endScrub() {
    if (_activeHour == null) return;
    setState(() => _activeHour = null);
  }
}

class _HeatmapScrubArea extends StatelessWidget {
  final List<StatisticsHeatmapCellViewModel> cells;
  final int? activeHour;
  final double readoutCenterX;
  final bool inspecting;
  final void Function(Offset localPosition, double width) onScrub;
  final VoidCallback onEnd;

  const _HeatmapScrubArea({
    required this.cells,
    required this.activeHour,
    required this.readoutCenterX,
    required this.inspecting,
    required this.onScrub,
    required this.onEnd,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Listener(
          onPointerDown: (event) => onScrub(
            event.localPosition,
            constraints.maxWidth,
          ),
          onPointerMove: (event) => onScrub(
            event.localPosition,
            constraints.maxWidth,
          ),
          onPointerUp: (_) => onEnd(),
          onPointerCancel: (_) => onEnd(),
          child: SizedBox(
            height: 62,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  top: 24,
                  child: Row(
                    children: [
                      for (var index = 0; index < cells.length; index++)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                              right: index == cells.length - 1 ? 0 : 3,
                            ),
                            child: _HeatmapCell(
                              cell: cells[index],
                              active: activeHour == index,
                              dimmed: inspecting && activeHour != index,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                _HeatmapReadout(
                  cell: activeHour == null ? null : cells[activeHour!],
                  centerX: readoutCenterX,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HeatmapCell extends StatelessWidget {
  final StatisticsHeatmapCellViewModel cell;
  final bool active;
  final bool dimmed;

  const _HeatmapCell({
    required this.cell,
    required this.active,
    required this.dimmed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 140),
      opacity: dimmed ? 0.4 : 1,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        height: 30,
        transform: Matrix4.translationValues(0, active ? -2 : 0, 0),
        decoration: BoxDecoration(
          color: cell.color,
          borderRadius: BorderRadius.circular(4),
          border: active
              ? Border.all(color: AppColors.text.withOpacity(0.86), width: 1.5)
              : null,
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x99000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                    spreadRadius: -3,
                  ),
                ]
              : null,
        ),
      ),
    );
  }
}

class _HeatmapReadout extends StatelessWidget {
  final StatisticsHeatmapCellViewModel? cell;
  final double centerX;

  const _HeatmapReadout({
    required this.cell,
    required this.centerX,
  });

  @override
  Widget build(BuildContext context) {
    final cell = this.cell;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
      left: centerX,
      top: 0,
      child: FractionalTranslation(
        translation: const Offset(-0.5, 0),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 140),
          opacity: cell == null ? 0 : 1,
          child: cell == null
              ? const SizedBox.shrink()
              : Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xF20A0F0C),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(color: AppColors.borderMid),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xB3000000),
                            blurRadius: 18,
                            offset: Offset(0, 6),
                            spreadRadius: -8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cell.timeLabel,
                            style: const TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSoft,
                            ),
                          ),
                          const _ReadoutSeparator(),
                          Text(
                            cell.tirLabel,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: cell.tagColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            cell.tagLabel,
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: cell.tagColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: -4,
                      child: Transform.rotate(
                        angle: 0.785398,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Color(0xF20A0F0C),
                            border: Border(
                              right: BorderSide(color: AppColors.borderMid),
                              bottom: BorderSide(color: AppColors.borderMid),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _ReadoutSeparator extends StatelessWidget {
  const _ReadoutSeparator();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 13,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: AppColors.borderMid,
    );
  }
}

class _HeatmapLabel extends StatelessWidget {
  final String text;

  const _HeatmapLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'JetBrainsMono',
        fontSize: 10,
        color: AppColors.textDim,
      ),
    );
  }
}
