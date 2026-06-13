import 'package:flutter/material.dart';

enum AnnotationLabelPosition { top, bottom }

class AgpAnnotation {
  final int minuteOfDay;
  final List<String> labels;
  final Color color;
  final double opacity;
  final AnnotationLabelPosition labelPosition;

  const AgpAnnotation({
    required this.minuteOfDay,
    required this.labels,
    required this.color,
    this.opacity = 0.5,
    this.labelPosition = AnnotationLabelPosition.top,
  });
}

class AgpScrubSample {
  final int minuteOfDay;
  final double median;
  final double iqrLow;
  final double iqrHigh;
  final Offset medianPoint;
  final double iqrTopY;
  final double iqrBottomY;

  const AgpScrubSample({
    required this.minuteOfDay,
    required this.median,
    required this.iqrLow,
    required this.iqrHigh,
    required this.medianPoint,
    required this.iqrTopY,
    required this.iqrBottomY,
  });
}
