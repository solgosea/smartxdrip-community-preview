class IosBgTaskError implements Exception {
  final String message;

  const IosBgTaskError(this.message);

  @override
  String toString() => 'IosBgTaskError: $message';
}
