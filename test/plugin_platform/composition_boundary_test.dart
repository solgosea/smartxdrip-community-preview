import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('plugin platform remains independent from concrete plugins', () {
    final root = Directory.current;
    final files =
        root.listSync(recursive: true).whereType<File>().where((file) {
      final path = file.path.replaceAll('\\', '/');
      return path.endsWith('.dart') && path.contains('/lib/plugin_platform/');
    }).toList(growable: false);

    final violations = <String>[];
    for (final file in files) {
      final path = file.path.replaceAll('\\', '/');
      final content = file.readAsStringSync();
      if (content.contains("package:smart_xdrip/plugins/") ||
          content.contains("../../plugins/") ||
          content.contains("../plugins/")) {
        violations.add(path);
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}
