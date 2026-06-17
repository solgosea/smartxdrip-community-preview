import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../charts/report_svg_chart_builder.dart';
import '../models/report_section.dart';
import '../models/report_view_model.dart';

class GlucoseReportPdfBuilder {
  final ReportSvgChartBuilder chartBuilder;

  const GlucoseReportPdfBuilder({
    this.chartBuilder = const ReportSvgChartBuilder(),
  });

  Future<Uint8List> build(ReportViewModel viewModel) async {
    final doc = pw.Document(
      title: 'Solgo Insight Glucose Report',
      author: 'Solgo Insight',
      creator: 'Solgo Insight',
    );
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(36, 32, 36, 28),
        build: (_) => [
          _header(viewModel),
          pw.SizedBox(height: 14),
          if (_enabled(viewModel, ReportSectionKey.keyMetrics))
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(child: _ranges(viewModel)),
                pw.SizedBox(width: 16),
                pw.Expanded(child: _metrics(viewModel)),
              ],
            ),
          if (_enabled(viewModel, ReportSectionKey.agpChart)) ...[
            pw.SizedBox(height: 16),
            _agp(viewModel),
          ],
          if (_enabled(viewModel, ReportSectionKey.dailyCurves)) ...[
            pw.SizedBox(height: 16),
            _daily(viewModel),
          ],
          if (_enabled(viewModel, ReportSectionKey.periodAnalysis)) ...[
            pw.SizedBox(height: 16),
            _periodAnalysis(viewModel),
          ],
          if (_enabled(viewModel, ReportSectionKey.episodesSummary)) ...[
            pw.SizedBox(height: 16),
            _episodesSummary(viewModel),
          ],
          pw.Spacer(),
          _footer(viewModel),
        ],
      ),
    );
    return doc.save();
  }

  bool _enabled(ReportViewModel vm, ReportSectionKey key) =>
      vm.sections.any((section) => section.key == key && section.enabled);

  pw.Widget _header(ReportViewModel vm) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.black, width: 2),
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(
                      text: 'Solgo Insight',
                      style: pw.TextStyle(
                        fontSize: 13,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    const pw.TextSpan(
                      text: '  Glucose Report',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 3),
              pw.Text(
                'Period: ${_pdfText(vm.header.periodLabel)}',
                style:
                    const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.Text(
                '${vm.header.readingsLabel} - ${vm.header.coverageLabel}',
                style:
                    const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
              ),
            ],
          ),
          pw.Text(
            _pdfText(
              'Data source: ${vm.header.dataSourceLabel}\n'
              'Target range: ${vm.header.targetRangeLabel}\n'
              'Generated: ${vm.header.generatedLabel}',
            ),
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(bottom: 4),
      margin: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.grey300),
        ),
      ),
      child: pw.Text(
        title.toUpperCase(),
        style: pw.TextStyle(
          fontSize: 9,
          letterSpacing: 1.4,
          color: PdfColors.grey700,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _ranges(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Time in Ranges'),
        pw.Container(
          height: 14,
          decoration:
              pw.BoxDecoration(borderRadius: pw.BorderRadius.circular(3)),
          child: pw.Row(
            children: [
              for (final range in vm.ranges)
                pw.Expanded(
                  flex: range.percent.round().clamp(1, 100),
                  child: pw.Container(color: _rangeColor(range.tone)),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        for (final range in vm.ranges)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(vertical: 3),
            child: pw.Row(
              children: [
                pw.Container(
                  width: 8,
                  height: 8,
                  decoration: pw.BoxDecoration(
                    color: _rangeColor(range.tone),
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Text(
                    '${range.label} ${_pdfText(range.thresholdLabel)}'
                    '${range.levelLabel == null ? '' : '  ${range.levelLabel}'}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ),
                pw.Text(
                  '${range.percent.toStringAsFixed(0)}%',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: _rangeColor(range.tone),
                  ),
                ),
                pw.SizedBox(width: 12),
                pw.Text(
                  '${range.minutesPerDay} min/day',
                  style:
                      const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _metrics(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Key Metrics'),
        pw.Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final metric in vm.metrics)
              pw.Container(
                width: 105,
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      metric.label.toUpperCase(),
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _pdfText(metric.value),
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: _metricColor(metric.tone),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      _pdfText(metric.unit),
                      style: const pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  pw.Widget _agp(ReportViewModel vm) {
    final svg = chartBuilder.agp(
      slots: vm.agpSlots,
      settings: vm.settings,
      width: 722,
      height: 160,
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle(
          'Ambulatory Glucose Profile (AGP) - ${vm.selectedPeriod.days} days',
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            _legend('#1a9e5c', 'Median (p50)'),
            pw.SizedBox(width: 12),
            _legend('#7dc79f', 'IQR (p25-p75)'),
            pw.SizedBox(width: 12),
            _legend('#b9dec7', 'p10-p90'),
          ],
        ),
        pw.SizedBox(height: 6),
        if (vm.agpSlots.isEmpty)
          _emptyBox(vm.emptyText)
        else
          pw.SvgImage(svg: svg),
      ],
    );
  }

  pw.Widget _legend(String hex, String label) {
    return pw.Row(
      children: [
        pw.Container(width: 14, height: 8, color: PdfColor.fromHex(hex)),
        pw.SizedBox(width: 5),
        pw.Text(label,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
      ],
    );
  }

  pw.Widget _daily(ReportViewModel vm) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Daily Glucose - last 14 days'),
        for (final day in vm.dailyCurves)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 3),
            child: pw.Row(
              children: [
                pw.SizedBox(
                  width: 42,
                  child: pw.Text(
                    day.dayLabel,
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey600,
                    ),
                  ),
                ),
                pw.Expanded(
                  child: pw.Container(
                    height: 20,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      border: pw.Border.all(color: PdfColors.grey300),
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                    child: day.sparse
                        ? pw.Center(
                            child: pw.Text(
                              'sparse data - excluded',
                              style: const pw.TextStyle(
                                fontSize: 8,
                                color: PdfColors.grey500,
                              ),
                            ),
                          )
                        : pw.SvgImage(
                            svg: chartBuilder.dailyCurve(
                              day: day,
                              settings: vm.settings,
                            ),
                          ),
                  ),
                ),
                pw.SizedBox(
                  width: 38,
                  child: pw.Text(
                    day.tir == null ? '-' : '${day.tir!.toStringAsFixed(0)}%',
                    textAlign: pw.TextAlign.right,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: day.tir == null
                          ? PdfColors.grey500
                          : day.tir! >= 70
                              ? PdfColor.fromHex('#1a9e5c')
                              : day.tir! >= 55
                                  ? PdfColor.fromHex('#d4861a')
                                  : PdfColor.fromHex('#c94040'),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _periodAnalysis(ReportViewModel vm) {
    final analysis = vm.periodAnalysis;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Period Analysis'),
        if (!analysis.hasData)
          _emptyBox(analysis.summaryText)
        else ...[
          pw.Text(
            analysis.summaryText,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: .5),
            columnWidths: const {
              0: pw.FlexColumnWidth(1.2),
              1: pw.FlexColumnWidth(1),
              2: pw.FlexColumnWidth(.8),
              3: pw.FlexColumnWidth(.8),
              4: pw.FlexColumnWidth(1),
            },
            children: [
              _periodRow(
                ['Period', 'Avg', 'TIR', 'CV', 'Peak'],
                header: true,
              ),
              for (final row in analysis.rows)
                _periodRow([
                  row.label,
                  row.averageLabel,
                  row.tirLabel,
                  row.cvLabel,
                  row.peakLabel,
                ]),
            ],
          ),
        ],
      ],
    );
  }

  pw.TableRow _periodRow(List<String> cells, {bool header = false}) {
    return pw.TableRow(
      decoration:
          header ? const pw.BoxDecoration(color: PdfColors.grey100) : null,
      children: [
        for (final cell in cells)
          pw.Padding(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: pw.Text(
              _pdfText(cell),
              style: pw.TextStyle(
                fontSize: header ? 8 : 9,
                fontWeight: header ? pw.FontWeight.bold : pw.FontWeight.normal,
                color: header ? PdfColors.grey700 : PdfColors.black,
              ),
            ),
          ),
      ],
    );
  }

  pw.Widget _episodesSummary(ReportViewModel vm) {
    final summary = vm.episodesSummary;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        _sectionTitle('Episodes Summary'),
        if (!summary.hasData)
          _emptyBox(summary.summaryText)
        else
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Text(
                  summary.summaryText,
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _episodeMetric('High episodes', '${summary.highCount}'),
                    _episodeMetric('Low episodes', '${summary.lowCount}'),
                    _episodeMetric('Avg high', summary.avgHighDurationLabel),
                    _episodeMetric('Avg low', summary.avgLowDurationLabel),
                    _episodeMetric(
                      'Nocturnal lows',
                      '${summary.nocturnalLowCount}',
                    ),
                    _episodeMetric('Highest', summary.highestLabel),
                    _episodeMetric('Lowest', summary.lowestLabel),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _episodeMetric(String label, String value) {
    return pw.Container(
      width: 110,
      padding: const pw.EdgeInsets.all(7),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label.toUpperCase(),
            style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey600),
          ),
          pw.SizedBox(height: 3),
          pw.Text(
            _pdfText(value),
            style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          ),
        ],
      ),
    );
  }

  pw.Widget _emptyBox(String text) {
    return pw.Container(
      height: 46,
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Text(
        _pdfText(text),
        style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
      ),
    );
  }

  pw.Widget _footer(ReportViewModel vm) {
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 8),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey300)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            'CGM readings only - No insulin or carb data included\n'
            'Not a medical device - For informational purposes only',
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
          pw.Text(
            'Solgo Insight - local report\nPrinted ${_pdfText(vm.header.generatedLabel)}',
            textAlign: pw.TextAlign.right,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500),
          ),
        ],
      ),
    );
  }

  PdfColor _rangeColor(ReportRangeTone tone) {
    return switch (tone) {
      ReportRangeTone.veryHigh => PdfColor.fromHex('#c94040'),
      ReportRangeTone.high => PdfColor.fromHex('#d4861a'),
      ReportRangeTone.inRange => PdfColor.fromHex('#1a9e5c'),
      ReportRangeTone.low => PdfColor.fromHex('#5aaddf'),
      ReportRangeTone.veryLow => PdfColor.fromHex('#2563a8'),
    };
  }

  PdfColor _metricColor(ReportMetricTone tone) {
    return switch (tone) {
      ReportMetricTone.green => PdfColor.fromHex('#1a9e5c'),
      ReportMetricTone.amber => PdfColor.fromHex('#b07a1a'),
      ReportMetricTone.blue => PdfColor.fromHex('#2d7ab0'),
      ReportMetricTone.neutral => PdfColors.black,
    };
  }

  String _pdfText(String input) => input;
}
