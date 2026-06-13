import '../target_range_value_policy.dart';

class TargetRangeValidationResult {
  final bool isValid;
  final TargetRangeMarker? invalidMarker;
  final String message;

  const TargetRangeValidationResult({
    required this.isValid,
    this.invalidMarker,
    this.message = '',
  });

  const TargetRangeValidationResult.valid()
      : isValid = true,
        invalidMarker = null,
        message = '';
}
