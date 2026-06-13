import '../../../../domain/entities/app_settings.dart';
import '../target_range_value_policy.dart';
import 'target_range_validation_result.dart';

class TargetRangeEditState {
  final TargetRangeDraft draft;
  final TargetRangeDraft initialDraft;
  final GlucoseUnit displayUnit;
  final TargetRangeMarker? activeMarker;
  final TargetRangeValidationResult validation;

  const TargetRangeEditState({
    required this.draft,
    required this.initialDraft,
    required this.displayUnit,
    required this.validation,
    this.activeMarker,
  });

  bool get canSave => validation.isValid;

  bool get hasChanges =>
      draft.lowMmol != initialDraft.lowMmol ||
      draft.highMmol != initialDraft.highMmol ||
      draft.veryHighMmol != initialDraft.veryHighMmol;

  TargetRangeEditState copyWith({
    TargetRangeDraft? draft,
    TargetRangeDraft? initialDraft,
    GlucoseUnit? displayUnit,
    TargetRangeMarker? activeMarker,
    bool clearActiveMarker = false,
    TargetRangeValidationResult? validation,
  }) {
    return TargetRangeEditState(
      draft: draft ?? this.draft,
      initialDraft: initialDraft ?? this.initialDraft,
      displayUnit: displayUnit ?? this.displayUnit,
      activeMarker:
          clearActiveMarker ? null : activeMarker ?? this.activeMarker,
      validation: validation ?? this.validation,
    );
  }
}
