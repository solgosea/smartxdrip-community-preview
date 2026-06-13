import 'package:smart_xdrip/application/insight/default_insight_templates.dart';
import 'package:smart_xdrip/application/insight/insight_template_renderer.dart';
import 'package:smart_xdrip/application/insight/insight_template_selector.dart';
import 'package:smart_xdrip/domain/analysis/analysis_module_code.dart';
import 'package:smart_xdrip/domain/insight/insight_fact_bundle.dart';
import 'package:smart_xdrip/domain/insight/insight_slot_code.dart';
import 'package:smart_xdrip/domain/insight/insight_type_code.dart';

class StatisticsAgpTextRenderer {
  final InsightTemplateSelector selector;
  final InsightTemplateRenderer renderer;

  const StatisticsAgpTextRenderer({
    this.selector = const InsightTemplateSelector(),
    this.renderer = const InsightTemplateRenderer(),
  });

  String renderEmpty() {
    return _render(
      type: InsightTypeCode.agpNoData,
      facts: const {'notEnoughData': true},
    );
  }

  String renderDawn(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpDawnRise, facts: facts);
  }

  String renderPeak(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpMedianPeak, facts: facts);
  }

  String renderVariability(Map<String, Object?> facts) {
    return _render(type: InsightTypeCode.agpVariability, facts: facts);
  }

  String _render({
    required InsightTypeCode type,
    required Map<String, Object?> facts,
  }) {
    final bundle = InsightFactBundle(
      module: AnalysisModuleCode.insights,
      slot: InsightSlotCode.agpSummary,
      type: type,
      facts: facts,
    );
    final template = selector.select(bundle, DefaultInsightTemplates.all);
    if (template == null) {
      throw StateError('Missing statistics AGP template for ${type.code}');
    }
    return renderer.render(template, facts).body;
  }
}
