class GlucoseSourceHttpResult {
  final bool reachable;
  final int? statusCode;
  final Duration elapsed;
  final dynamic data;
  final Object? error;

  const GlucoseSourceHttpResult({
    required this.reachable,
    this.statusCode,
    required this.elapsed,
    this.data,
    this.error,
  });
}
