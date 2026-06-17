import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory.current;

  test('statistics mapper does not own engine calculations', () {
    final mapper = File(
      '${root.path}/lib/plugins/statistics/mappers/statistics_view_model_mapper.dart',
    );
    final text = mapper.readAsStringSync();

    expect(text, isNot(contains('AnalysisFacade')));
    expect(text, isNot(contains('DawnPhenomenonDetector')));
    expect(text, isNot(contains('tirForReadings')));
    expect(text, isNot(contains('agpForReadings')));
    expect(text, isNot(contains('hourlyTirForReadings')));
    expect(text, isNot(contains('readingsForWindow')));
    expect(text, isNot(contains('Time in Range')));
    expect(text, isNot(contains('Avg Glucose')));
    expect(text, isNot(contains('Variability CV')));
    expect(text, isNot(contains('Std Deviation')));
    expect(text, isNot(contains('Hourly TIR heatmap')));
    expect(text, isNot(contains('AGP is more meaningful')));
  });

  test('legacy statistics analysis renderer path is removed', () {
    final analysisDir =
        Directory('${root.path}/lib/plugins/statistics/analysis');
    final dartFiles = _dartFiles(analysisDir).map(_relative).toList();
    expect(dartFiles, isEmpty);
  });

  test('statistics engine is free of Flutter UI imports', () {
    final engineDir = Directory('${root.path}/lib/plugins/statistics/engine');
    final violations = _dartFiles(engineDir)
        .where(
          (file) => _containsAny(file, const [
            "package:flutter/material.dart",
            "package:flutter/widgets.dart",
            "plugins/statistics/widgets",
            "plugins/statistics/mappers",
          ]),
        )
        .map(_relative)
        .toList();

    expect(violations, isEmpty);
  });

  test('statistics widgets do not import engine or text builders', () {
    final widgetsDir = Directory('${root.path}/lib/plugins/statistics/widgets');
    final violations = _dartFiles(widgetsDir)
        .where(
          (file) => _containsAny(file, const [
            "plugins/statistics/engine",
            "plugins/statistics/application/text",
            "application/analysis/analysis_facade.dart",
          ]),
        )
        .map(_relative)
        .toList();

    expect(violations, isEmpty);
  });

  test('statistics widgets are grouped by section directories', () {
    final expected = <String>[
      'header/statistics_header.dart',
      'controls/statistics_period_tabs.dart',
      'metrics/statistics_metrics_header.dart',
      'metrics/statistics_metric_grid.dart',
      'metrics/statistics_metric_card.dart',
      'tir/statistics_tir_breakdown_card.dart',
      'tir/statistics_legend_dot.dart',
      'tir/statistics_extreme_cell.dart',
      'agp/statistics_agp_card.dart',
      'heatmap/statistics_heatmap_card.dart',
      'shared/statistics_section_card.dart',
    ];

    for (final path in expected) {
      expect(
        File('${root.path}/lib/plugins/statistics/widgets/$path').existsSync(),
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
