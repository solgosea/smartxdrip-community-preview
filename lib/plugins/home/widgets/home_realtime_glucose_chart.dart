import 'package:flutter/material.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/glucose_line_chart.dart';
import '../models/home_view_model.dart';

class HomeRealtimeGlucoseChart extends StatelessWidget {
  final HomeViewModel viewModel;
  final ValueChanged<bool> onInspectionChanged;

  const HomeRealtimeGlucoseChart({
    super.key,
    required this.viewModel,
    required this.onInspectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlucoseLineChart(
      readings: viewModel.chartReadings,
      unit: viewModel.unit,
      low: viewModel.lowThreshold,
      high: viewModel.highThreshold,
      height: 160,
      showCurrentDot: true,
      enableInspection: true,
      onInspectionChanged: onInspectionChanged,
      coloringMode: ChartColoringMode.single,
      thresholdLineMode: ThresholdLineMode.subtle,
      xLabelMode: XLabelMode.hourMinute,
      xLabelCount: 5,
    );
  }
}
