abstract class DatasourceCapability {
  bool get hasConfiguredSource;

  Future<void> requestSync({required String reason});
}
