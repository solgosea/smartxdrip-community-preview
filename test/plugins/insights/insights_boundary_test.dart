import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory.current;

  test('insights mapper does not read facade or global insight slots directly',
      () {
    final mapperDir = Directory('${root.path}/lib/plugins/insights/mappers');
    final violations = _dartFiles(mapperDir)
        .where(
          (file) => _containsAny(file, const [
            'AnalysisFacade',
            'InsightSlotCode',
            'InsightTypeCode',
            'NarrativeInsight',
          ]),
        )
        .map(_relative)
        .toList();

    expect(violations, isEmpty);
  });

  test('insights engine is free of Flutter and presentation imports', () {
    final engineDir = Directory('${root.path}/lib/plugins/insights/engine');
    final violations = _dartFiles(engineDir)
        .where(
          (file) => _containsAny(file, const [
            "package:flutter/",
            "plugins/insights/widgets",
            "plugins/insights/mappers",
            "plugins/insights/application/text",
          ]),
        )
        .map(_relative)
        .toList();

    expect(violations, isEmpty);
  });

  test('insights widgets do not import engine or text builders', () {
    final widgetsDir = Directory('${root.path}/lib/plugins/insights/widgets');
    final violations = _dartFiles(widgetsDir)
        .where(
          (file) => _containsAny(file, const [
            "plugins/insights/engine",
            "plugins/insights/application/text",
            "application/analysis/analysis_facade.dart",
          ]),
        )
        .map(_relative)
        .toList();

    expect(violations, isEmpty);
  });

  test('insights widgets are grouped by section directories', () {
    final expected = <String>[
      'header/insights_header.dart',
      'daily/daily_brief_card.dart',
      'weekly/weekly_review_card.dart',
      'weekly/insight_mini_stat.dart',
      'patterns/insight_pattern_card.dart',
      'patterns/insight_pattern_list.dart',
      'shared/insight_section_label.dart',
    ];

    for (final path in expected) {
      expect(
        File('${root.path}/lib/plugins/insights/widgets/$path').existsSync(),
        isTrue,
        reason: path,
      );
    }
  });
}

Iterable<File> _dartFiles(Directory dir) {
  if (!dir.existsSync()) return const <File>[];
  return dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'));
}

bool _containsAny(File file, List<String> needles) {
  final text = file.readAsStringSync();
  return needles.any(text.contains);
}

String _relative(File file) {
  final root = Directory.current.path.replaceAll('\\', '/');
  return file.path.replaceAll('\\', '/').replaceFirst('$root/', '');
}
