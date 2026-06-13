import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entities/app_settings.dart';
import '../../../foundation/theme/app_colors.dart';
import 'editing/target_range_edit_controller.dart';
import 'editing/target_range_edit_state.dart';
import 'editing/target_range_input_formatter.dart';
import 'target_range_value_policy.dart';
import 'widgets/target_range_exact_values_section.dart';
import 'widgets/target_range_hero_card.dart';
import 'widgets/target_range_ruler_card.dart';
import 'widgets/target_range_sheet_actions.dart';
import 'widgets/target_range_sheet_handle.dart';
import 'widgets/target_range_sheet_header.dart';
import 'widgets/target_range_unit_segment.dart';
import 'widgets/target_range_validation_banner.dart';

class TargetRangeRulerSheet extends StatefulWidget {
  final AppSettings settings;
  final TargetRangeEditController editController;
  final TargetRangeInputFormatter inputFormatter;

  const TargetRangeRulerSheet({
    super.key,
    required this.settings,
    this.editController = const TargetRangeEditController(),
    this.inputFormatter = const TargetRangeInputFormatter(),
  });

  @override
  State<TargetRangeRulerSheet> createState() => _TargetRangeRulerSheetState();
}

class _TargetRangeRulerSheetState extends State<TargetRangeRulerSheet> {
  late TargetRangeEditState _state;

  final _lowController = TextEditingController();
  final _highController = TextEditingController();
  final _veryHighController = TextEditingController();

  final _lowFocusNode = FocusNode();
  final _highFocusNode = FocusNode();
  final _veryHighFocusNode = FocusNode();

  bool _syncingText = false;

  @override
  void initState() {
    super.initState();
    _state = widget.editController.initialize(widget.settings);
    _syncTextControllers(force: true);
  }

  @override
  void dispose() {
    _lowController.dispose();
    _highController.dispose();
    _veryHighController.dispose();
    _lowFocusNode.dispose();
    _highFocusNode.dispose();
    _veryHighFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final maxHeight = MediaQuery.of(context).size.height * 0.96;
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: const Border(
                top: BorderSide(color: AppColors.borderMid),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 24,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const TargetRangeSheetHandle(),
                  TargetRangeSheetHeader(onReset: _resetToDefault),
                  const SizedBox(height: 16),
                  TargetRangeUnitSegment(
                    unit: _state.displayUnit,
                    onChanged: _switchDisplayUnit,
                  ),
                  const SizedBox(height: 16),
                  TargetRangeHeroCard(
                    draft: _state.draft,
                    unit: _state.displayUnit,
                  ),
                  const SizedBox(height: 18),
                  TargetRangeRulerCard(
                    draft: _state.draft,
                    unit: _state.displayUnit,
                    activeMarker: _state.activeMarker,
                    onMarkerActiveChanged: _setActiveMarker,
                    onChanged: _updateMarker,
                  ),
                  TargetRangeExactValuesSection(
                    state: _state,
                    lowController: _lowController,
                    highController: _highController,
                    veryHighController: _veryHighController,
                    lowFocusNode: _lowFocusNode,
                    highFocusNode: _highFocusNode,
                    veryHighFocusNode: _veryHighFocusNode,
                    onStep: _stepValue,
                    onChanged: _updateExactValue,
                  ),
                  TargetRangeValidationBanner(validation: _state.validation),
                  const SizedBox(height: 18),
                  TargetRangeSheetActions(
                    canSave: _state.canSave,
                    onCancel: () => Navigator.pop(context),
                    onSave: () => Navigator.pop(context, _state.draft),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _switchDisplayUnit(GlucoseUnit unit) {
    HapticFeedback.selectionClick();
    setState(() {
      _state = widget.editController.switchDisplayUnit(_state, unit);
      _syncTextControllers(force: true);
    });
  }

  void _resetToDefault() {
    HapticFeedback.mediumImpact();
    setState(() {
      _state = widget.editController.resetToDefault(_state);
      _syncTextControllers(force: true);
    });
  }

  void _setActiveMarker(TargetRangeMarker? marker) {
    setState(() {
      _state = marker == null
          ? widget.editController.clearActiveMarker(_state)
          : _state.copyWith(activeMarker: marker);
    });
  }

  void _updateMarker(TargetRangeMarker marker, double valueMmol) {
    setState(() {
      _state = widget.editController.updateMarker(
        state: _state,
        marker: marker,
        valueMmol: valueMmol,
      );
      _syncTextControllers();
    });
  }

  void _stepValue(TargetRangeMarker marker, int direction) {
    HapticFeedback.selectionClick();
    setState(() {
      _state = widget.editController.stepValue(
        state: _state,
        marker: marker,
        direction: direction,
      );
      _syncTextControllers(force: true);
    });
  }

  void _updateExactValue(TargetRangeMarker marker, String value) {
    if (_syncingText) return;
    try {
      setState(() {
        _state = widget.editController.updateExactValue(
          state: _state,
          marker: marker,
          rawDisplayValue: value,
        );
        _syncTextControllers(skipFocused: marker);
      });
    } on FormatException {
      setState(() {
        _state = _state.copyWith(
          activeMarker: marker,
          validation: widget.editController.validate(
            _state.draft,
            _state.displayUnit,
          ),
        );
      });
    }
  }

  void _syncTextControllers({
    bool force = false,
    TargetRangeMarker? skipFocused,
  }) {
    _syncingText = true;
    _setText(
      _lowController,
      widget.inputFormatter.label(_state.draft.lowMmol, _state.displayUnit),
      focusNode: _lowFocusNode,
      force: force,
      skip: skipFocused == TargetRangeMarker.low,
    );
    _setText(
      _highController,
      widget.inputFormatter.label(_state.draft.highMmol, _state.displayUnit),
      focusNode: _highFocusNode,
      force: force,
      skip: skipFocused == TargetRangeMarker.high,
    );
    _setText(
      _veryHighController,
      widget.inputFormatter.label(
        _state.draft.veryHighMmol,
        _state.displayUnit,
      ),
      focusNode: _veryHighFocusNode,
      force: force,
      skip: skipFocused == TargetRangeMarker.veryHigh,
    );
    _syncingText = false;
  }

  void _setText(
    TextEditingController controller,
    String text, {
    required FocusNode focusNode,
    required bool force,
    required bool skip,
  }) {
    if (skip && focusNode.hasFocus && !force) return;
    if (!force && focusNode.hasFocus) return;
    if (controller.text == text) return;
    controller.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
