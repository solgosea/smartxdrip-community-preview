import 'package:flutter/material.dart';
import '../../../domain/entities/app_settings.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';
import 'home_render_scope.dart';
import 'home_slot_host.dart';

class HomeBody extends StatefulWidget {
  final HomeViewModel viewModel;
  final ValueChanged<HomeChartRange> onRangeChanged;
  final ValueChanged<GlucoseUnit> onUnitChanged;
  final VoidCallback onInsightTap;
  final VoidCallback onSwitchBackToSelf;

  const HomeBody({
    super.key,
    required this.viewModel,
    required this.onRangeChanged,
    required this.onUnitChanged,
    required this.onInsightTap,
    required this.onSwitchBackToSelf,
  });

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  bool _inspectingPast = false;

  void _handleInspectionChanged(bool value) {
    if (_inspectingPast == value) return;
    setState(() => _inspectingPast = value);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            HomeRenderScope(
              viewModel: widget.viewModel,
              inspectingPast: _inspectingPast,
              onRangeChanged: widget.onRangeChanged,
              onInspectionChanged: _handleInspectionChanged,
              onInsightTap: widget.onInsightTap,
              onSwitchBackToSelf: widget.onSwitchBackToSelf,
              onUnitChanged: widget.onUnitChanged,
              child: const HomeSlotHost(),
            ),
          ],
        ),
      ),
    );
  }
}
