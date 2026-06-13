import 'package:flutter/widgets.dart';

import '../../../domain/entities/app_settings.dart';
import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';

class HomeRenderScope extends InheritedWidget {
  final HomeViewModel viewModel;
  final bool inspectingPast;
  final ValueChanged<HomeChartRange> onRangeChanged;
  final ValueChanged<bool> onInspectionChanged;
  final VoidCallback onInsightTap;
  final VoidCallback onSwitchBackToSelf;
  final ValueChanged<GlucoseUnit> onUnitChanged;

  const HomeRenderScope({
    super.key,
    required this.viewModel,
    required this.inspectingPast,
    required this.onRangeChanged,
    required this.onInspectionChanged,
    required this.onInsightTap,
    required this.onSwitchBackToSelf,
    required this.onUnitChanged,
    required super.child,
  });

  static HomeRenderScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HomeRenderScope>();
    assert(scope != null, 'HomeRenderScope was not found.');
    return scope!;
  }

  @override
  bool updateShouldNotify(HomeRenderScope oldWidget) {
    return viewModel != oldWidget.viewModel ||
        inspectingPast != oldWidget.inspectingPast;
  }
}
