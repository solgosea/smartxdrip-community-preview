import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../../../../domain/entities/app_settings.dart';
import '../../../../../foundation/theme/app_colors.dart';
import '../target_range_value_policy.dart';

class TargetRangeMultiMarkerRuler extends StatefulWidget {
  final TargetRangeDraft draft;
  final GlucoseUnit unit;
  final TargetRangeMarker? activeMarker;
  final ValueChanged<TargetRangeMarker?> onMarkerActiveChanged;
  final void Function(TargetRangeMarker marker, double valueMmol) onChanged;

  const TargetRangeMultiMarkerRuler({
    super.key,
    required this.draft,
    required this.unit,
    required this.activeMarker,
    required this.onMarkerActiveChanged,
    required this.onChanged,
  });

  @override
  State<TargetRangeMultiMarkerRuler> createState() =>
      _TargetRangeMultiMarkerRulerState();
}

class _TargetRangeMultiMarkerRulerState
    extends State<TargetRangeMultiMarkerRuler> {
  static const _formatter = GlucoseUnitFormatService();
  TargetRangeMarker? _dragging;

  @override
  Widget build(BuildContext context) {
    final activeValue = _valueFor(widget.activeMarker);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.max(1.0, constraints.maxWidth);
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (details) {
            final marker = _nearestMarker(details.localPosition.dx, width);
            _setActive(marker);
            _update(marker, details.localPosition.dx, width);
            Future<void>.delayed(const Duration(milliseconds: 520), () {
              if (!mounted || _dragging != null) return;
              _setActive(null);
            });
          },
          onPanStart: (details) {
            final marker = _nearestMarker(details.localPosition.dx, width);
            _dragging = marker;
            _setActive(marker);
            HapticFeedback.selectionClick();
            _update(marker, details.localPosition.dx, width);
          },
          onPanUpdate: (details) {
            final marker = _dragging;
            if (marker == null) return;
            _update(marker, details.localPosition.dx, width);
          },
          onPanEnd: (_) {
            _dragging = null;
            _setActive(null);
            HapticFeedback.lightImpact();
          },
          child: SizedBox(
            height: 112,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 48,
                  height: 20,
                  child: _RulerTrack(draft: widget.draft),
                ),
                Positioned.fill(
                  top: 70,
                  child: _RulerTicks(
                    unit: widget.unit,
                    activeValueMmol: activeValue,
                  ),
                ),
                _Marker(
                  left: _xFor(widget.draft.lowMmol, width),
                  color: AppColors.blue,
                  active: widget.activeMarker == TargetRangeMarker.low,
                  valueLabel: _formatter
                      .value(widget.draft.lowMmol, widget.unit)
                      .valueLabel,
                ),
                _Marker(
                  left: _xFor(widget.draft.highMmol, width),
                  color: AppColors.amber,
                  active: widget.activeMarker == TargetRangeMarker.high,
                  valueLabel: _formatter
                      .value(widget.draft.highMmol, widget.unit)
                      .valueLabel,
                ),
                _Marker(
                  left: _xFor(widget.draft.veryHighMmol, width),
                  color: AppColors.rose,
                  active: widget.activeMarker == TargetRangeMarker.veryHigh,
                  valueLabel: _formatter
                      .value(widget.draft.veryHighMmol, widget.unit)
                      .valueLabel,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double? _valueFor(TargetRangeMarker? marker) {
    return switch (marker) {
      TargetRangeMarker.low => widget.draft.lowMmol,
      TargetRangeMarker.high => widget.draft.highMmol,
      TargetRangeMarker.veryHigh => widget.draft.veryHighMmol,
      null => null,
    };
  }

  void _setActive(TargetRangeMarker? marker) {
    widget.onMarkerActiveChanged(marker);
  }

  void _update(TargetRangeMarker marker, double dx, double width) {
    widget.onChanged(marker, _mmolFor(dx, width));
  }

  TargetRangeMarker _nearestMarker(double dx, double width) {
    final positions = {
      TargetRangeMarker.low: _xFor(widget.draft.lowMmol, width),
      TargetRangeMarker.high: _xFor(widget.draft.highMmol, width),
      TargetRangeMarker.veryHigh: _xFor(widget.draft.veryHighMmol, width),
    };
    return positions.entries.reduce((best, entry) {
      return (entry.value - dx).abs() < (best.value - dx).abs() ? entry : best;
    }).key;
  }

  double _mmolFor(double dx, double width) {
    final normalized = (dx / width).clamp(0.0, 1.0);
    return TargetRangeValuePolicy.minMmol +
        normalized *
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol);
  }

  double _xFor(double mmol, double width) {
    final normalized = ((mmol - TargetRangeValuePolicy.minMmol) /
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol))
        .clamp(0.0, 1.0);
    return normalized * width;
  }
}

class _RulerTrack extends StatelessWidget {
  final TargetRangeDraft draft;

  const _RulerTrack({required this.draft});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.max(1.0, constraints.maxWidth - 6);
        final lowX = _xFor(draft.lowMmol, width);
        final highX = _xFor(draft.highMmol, width);
        final veryHighX = _xFor(draft.veryHighMmol, width);
        return Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.26),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: Colors.black.withOpacity(0.30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.34),
                blurRadius: 9,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Container(color: AppColors.bgCard2),
                _Zone(
                  color: AppColors.blue,
                  left: 0,
                  width: lowX,
                  opacity: 0.58,
                ),
                _Zone(
                  color: AppColors.green,
                  left: lowX,
                  width: highX - lowX,
                  opacity: 0.84,
                  emphasized: true,
                ),
                _Zone(
                  color: AppColors.amber,
                  left: highX,
                  width: veryHighX - highX,
                  opacity: 0.62,
                ),
                _Zone(
                  color: AppColors.rose,
                  left: veryHighX,
                  width: width - veryHighX,
                  opacity: 0.66,
                ),
                for (final seam in [lowX, highX, veryHighX]) _Seam(left: seam),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  height: 1,
                  child: Container(color: Colors.white.withOpacity(0.16)),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 2,
                  child: Container(color: Colors.black.withOpacity(0.20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  double _xFor(double mmol, double width) {
    final normalized = ((mmol - TargetRangeValuePolicy.minMmol) /
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol))
        .clamp(0.0, 1.0);
    return normalized * width;
  }
}

class _Zone extends StatelessWidget {
  final Color color;
  final double left;
  final double width;
  final double opacity;
  final bool emphasized;

  const _Zone({
    required this.color,
    required this.left,
    required this.width,
    required this.opacity,
    this.emphasized = false,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0,
      bottom: 0,
      width: math.max(0, width),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              color.withOpacity(math.min(1, opacity + 0.16)),
              color.withOpacity(opacity),
              color.withOpacity(math.max(0, opacity - 0.16)),
            ],
            stops: const [0, 0.45, 1],
          ),
        ),
        child: emphasized
            ? Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: 2,
                  color: Colors.white.withOpacity(0.22),
                ),
              )
            : null,
      ),
    );
  }
}

class _Seam extends StatelessWidget {
  final double left;

  const _Seam({required this.left});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left - 0.5,
      top: 0,
      bottom: 0,
      width: 1,
      child: Container(color: Colors.black.withOpacity(0.48)),
    );
  }
}

class _RulerTicks extends StatelessWidget {
  final GlucoseUnit unit;
  final double? activeValueMmol;

  const _RulerTicks({
    required this.unit,
    required this.activeValueMmol,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = math.max(1.0, constraints.maxWidth);
        return Stack(
          children: [
            for (var index = 0; index <= 32; index++)
              _Tick(
                left: _xFor(3 + index * 0.5, width),
                major: (3 + index * 0.5) % 2 == 0,
                medium: (3 + index * 0.5) % 1 == 0,
                highlighted: activeValueMmol != null &&
                    ((3 + index * 0.5) - activeValueMmol!).abs() <= 0.6,
                label: (3 + index * 0.5) % 2 == 0
                    ? const GlucoseUnitFormatService()
                        .value(3 + index * 0.5, unit)
                        .valueLabel
                    : null,
              ),
          ],
        );
      },
    );
  }

  double _xFor(double mmol, double width) {
    final normalized = ((mmol - TargetRangeValuePolicy.minMmol) /
            (TargetRangeValuePolicy.maxMmol - TargetRangeValuePolicy.minMmol))
        .clamp(0.0, 1.0);
    return normalized * width;
  }
}

class _Tick extends StatelessWidget {
  final double left;
  final bool major;
  final bool medium;
  final bool highlighted;
  final String? label;

  const _Tick({
    required this.left,
    required this.major,
    required this.medium,
    required this.highlighted,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    final height = major ? 9.0 : (medium ? 6.0 : 4.0);
    final opacity = highlighted ? 0.92 : (major ? 0.58 : 0.28);
    return Positioned(
      left: left,
      top: 0,
      child: Transform.translate(
        offset: const Offset(-0.5, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: highlighted ? 1.5 : 1,
              height: highlighted ? height + 3 : height,
              color: (highlighted ? AppColors.textSoft : AppColors.textDim)
                  .withOpacity(opacity),
            ),
            if (label != null) ...[
              const SizedBox(height: 3),
              Transform.translate(
                offset: const Offset(-9, 0),
                child: SizedBox(
                  width: 18,
                  child: Text(
                    label!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 8,
                      color:
                          (highlighted ? AppColors.textSoft : AppColors.textDim)
                              .withOpacity(highlighted ? 0.95 : 1),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Marker extends StatelessWidget {
  final double left;
  final Color color;
  final bool active;
  final String valueLabel;

  const _Marker({
    required this.left,
    required this.color,
    required this.active,
    required this.valueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: left,
      top: 0,
      child: Transform.translate(
        offset: const Offset(-13, 0),
        child: Column(
          children: [
            _ValueBubble(
              color: color,
              label: valueLabel,
              visible: active,
            ),
            const SizedBox(height: 5),
            AnimatedScale(
              duration: const Duration(milliseconds: 150),
              scale: active ? 1.12 : 1,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 150),
                    opacity: active ? 1 : 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.42),
                            blurRadius: 10,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(color: AppColors.bg, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.50),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: AppColors.bg.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Container(
                        width: 3,
                        height: 28,
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueBubble extends StatelessWidget {
  final Color color;
  final String label;
  final bool visible;

  const _ValueBubble({
    required this.color,
    required this.label,
    required this.visible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 150),
      opacity: visible ? 1 : 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        scale: visible ? 1 : 0.92,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.96),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.24),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'JetBrainsMono',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.bg,
                ),
              ),
            ),
            CustomPaint(
              size: const Size(10, 5),
              painter: _BubbleArrowPainter(color),
            ),
          ],
        ),
      ),
    );
  }
}

class _BubbleArrowPainter extends CustomPainter {
  final Color color;

  const _BubbleArrowPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width / 2, size.height)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(path, Paint()..color = color.withOpacity(0.96));
  }

  @override
  bool shouldRepaint(covariant _BubbleArrowPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
