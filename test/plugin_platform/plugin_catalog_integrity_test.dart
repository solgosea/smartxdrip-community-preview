import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_catalog_composer.dart';
import 'package:smart_xdrip/plugins/plugin_catalog.dart';

void main() {
  test('catalog can be projected into a composition graph', () {
    const composer = PluginCatalogComposer();
    final graph = composer.graphFor(pluginCatalog);
    final placements = composer.placementsFor(pluginCatalog);

    expect(graph.nodes.length, pluginCatalog.length);
    expect(placements, isNotEmpty);
    expect(
      placements.map((placement) => placement.slot.value).toSet(),
      containsAll(
        const [
          'app.mainTab',
          'home.widget',
          'profile.section',
          'settings.section',
          'explore.card',
        ],
      ),
    );
  });

  test('catalog plugin ids are unique', () {
    final ids = pluginCatalog.map((plugin) => plugin.id.value).toList();
    expect(ids.toSet().length, ids.length);
  });
}
