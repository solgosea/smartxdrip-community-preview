class XdripCloudConfig {
  static const _baseUrlFromEnvironment = String.fromEnvironment(
    'XDRIPCLOUD_BASE_URL',
    defaultValue: 'http://127.0.0.1:18081',
  );

  final String? baseUrl;

  const XdripCloudConfig({
    this.baseUrl = _baseUrlFromEnvironment,
  });

  bool get enabled => normalizedBaseUrl != null;

  String? get normalizedBaseUrl {
    final raw = baseUrl?.trim();
    if (raw == null || raw.isEmpty) return null;
    return raw.endsWith('/') ? raw.substring(0, raw.length - 1) : raw;
  }
}
