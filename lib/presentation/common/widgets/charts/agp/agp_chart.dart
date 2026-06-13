import 'package:flutter/material.dart';

import '../../../../../application/analysis/analysis_facade.dart';
import '../../../../../domain/entities/app_settings.dart';
import 'agp_chart_data.dart';
import 'agp_chart_geometry.dart';
import 'agp_chart_legend.dart';
import 'agp_chart_painter.dart';
import 'agp_chart_readout.dart';
import 'agp_chart_scrub_state.dart';
import 'agp_chart_style.dart';
import 'profile/agp_chart_profile.dart';
import 'profile/agp_compact_chart_profile.dart';
import 'scale/agp_y_scale.dart';

class AgpChart extends StatefulWidget {
  final List<AnalysisAgpSlot> slots;
  final GlucoseUnit unit;
  final double height;
  final double low;
  final double high;
  final List<AgpAnnotation> annotations;
  final bool? showTopBottomGrid;
  final int? xLabelStep;
  final bool showLegend;
  final bool enableScrub;
  final AgpChartStyle style;
  final AgpChartProfile profile;

  const AgpChart({
    super.key,
    required this.slots,
    required this.low,
    required this.high,
    this.unit = GlucoseUnit.mmolL,
    this.height = 200,
    this.annotations = const [],
    this.showTopBottomGrid,
    this.xLabelStep,
    this.showLegend = false,
    this.enableScrub = true,
    this.style = const AgpChartStyle(),
    this.profile = const AgpCompactChartProfile(),
  });

  @override
  State<AgpChart> createState() => _AgpChartState();
}

class _AgpChartState extends State<AgpChart> {
  AgpChartScrubState _scrub = AgpChartScrubState.idle;

  @override
  void didUpdateWidget(covariant AgpChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.slots != widget.slots || widget.slots.isEmpty) {
      _scrub = AgpChartScrubState.idle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chart = SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = Size(
            constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
            widget.height,
          );
          final scale = _scale();
          return Listener(
            onPointerDown: widget.enableScrub
                ? (event) => _inspect(event.localPosition, size)
                : null,
            onPointerMove: widget.enableScrub
                ? (event) => _inspect(event.localPosition, size)
                : null,
            onPointerUp: widget.enableScrub ? (_) => _endInspect() : null,
            onPointerCancel: widget.enableScrub ? (_) => _endInspect() : null,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 140),
                  opacity: _scrub.inspecting ? 0.76 : 1,
                  child: CustomPaint(
                    painter: AgpChartPainter(
                      slots: widget.slots,
                      unit: widget.unit,
                      low: widget.low,
                      high: widget.high,
                      annotations: widget.annotations,
                      showTopBottomGrid: widget.showTopBottomGrid ??
                          widget.profile.defaultShowTopBottomGrid,
                      xLabelStep:
                          widget.xLabelStep ?? widget.profile.defaultXLabelStep,
                      scrubSample: _scrub.sample,
                      style: widget.style,
                      yScale: scale,
                      profile: widget.profile,
                    ),
                    size: Size.infinite,
                  ),
                ),
                IgnorePointer(
                  child: AgpChartReadout(
                    sample: _scrub.sample,
                    unit: widget.unit,
                    style: widget.style,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    if (!widget.showLegend) return chart;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AgpChartLegend(
          unit: widget.unit,
          low: widget.low,
          high: widget.high,
          style: widget.style,
        ),
        chart,
      ],
    );
  }

  void _inspect(Offset localPosition, Size size) {
    if (widget.slots.isEmpty || size.width <= 0) return;
    final geometry = AgpChartGeometry(
      size: size,
      unit: widget.unit,
      yScale: _scale(),
    );
    final sample = geometry.nearestSample(
      slots: widget.slots,
      localX: localPosition.dx,
    );
    if (sample == null) return;
    setState(() {
      _scrub = _scrub.inspect(sample);
    });
  }

  AgpYScale _scale() {
    return widget.profile.createScale(
      slots: widget.slots,
      low: widget.low,
      high: widget.high,
    );
  }

  void _endInspect() {
    if (!_scrub.inspecting) return;
    setState(() {
      _scrub = AgpChartScrubState.idle;
    });
  }
}
