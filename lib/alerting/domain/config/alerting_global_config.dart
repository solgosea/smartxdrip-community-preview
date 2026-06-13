class AlertingGlobalConfig {
  static const strategyKey = 'global';
  final bool enabled;
  final bool criticalOnly;

  const AlertingGlobalConfig({
    this.enabled = false,
    this.criticalOnly = false,
  });

  Map<String, Object?> toJson() => {
        'enabled': enabled,
        'criticalOnly': criticalOnly,
      };

  static AlertingGlobalConfig fromJson(Map<String, Object?> json) {
    return AlertingGlobalConfig(
      enabled: json['enabled'] as bool? ?? false,
      criticalOnly: json['criticalOnly'] as bool? ?? false,
    );
  }
}
