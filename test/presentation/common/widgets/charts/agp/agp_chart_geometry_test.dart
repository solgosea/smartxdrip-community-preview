import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/agp_chart_geometry.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/agp_chart_viewport.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp/scale/agp_linear_y_scale.dart';

void main() {
  test('nearestSample snaps to the closest AGP slot and exposes IQR', () {
    const slots = [
      AnalysisAgpSlot(
        minuteOfDay: 0,
        p10: 4,
        p25: 5,
        p50: 6,
        p75: 7,
        p90: 8,
      ),
      AnalysisAgpSlot(
        minuteOfDay: 60,
        p10: 5,
        p25: 6,
        p50: 7,
        p75: 8,
        p90: 9,
      ),
    ];
    final geometry = AgpChartGeometry(
      size: const Size(330, 180),
      unit: GlucoseUnit.mmolL,
      yScale: AgpLinearYScale.fromViewport(
        AgpChartViewport.fromSlots(
          slots: slots,
          low: 3.9,
          high: 10,
        ),
      ),
    );

    final sample = geometry.nearestSample(
      slots: slots,
      localX: geometry.xForMinute(58),
    );

    expect(sample, isNotNull);
    expect(sample!.minuteOfDay, 60);
    expect(sample.median, 7);
    expect(sample.iqrLow, 6);
    expect(sample.iqrHigh, 8);
    expect(sample.iqrTopY, lessThan(sample.iqrBottomY));
  });

  test('minuteForX clamps pointer coordinates to the chart domain', () {
    final geometry = AgpChartGeometry(
      size: const Size(330, 180),
      unit: GlucoseUnit.mmolL,
      yScale: AgpLinearYScale.fromViewport(
        AgpChartViewport.fromSlots(
          slots: const [],
          low: 3.9,
          high: 10,
        ),
      ),
    );

    expect(geometry.minuteForX(-100), 0);
    expect(geometry.minuteForX(10000), 1440);
  });

  test('visual scale matches detail chart behavior and caps on wide screens',
      () {
    final yScale = AgpLinearYScale.fromViewport(
      AgpChartViewport.fromSlots(
        slots: const [],
        low: 3.9,
        high: 10,
      ),
    );
    final narrow = AgpChartGeometry(
      size: const Size(320, 180),
      unit: GlucoseUnit.mmolL,
      yScale: yScale,
    );
    final design = AgpChartGeometry(
      size: const Size(350, 180),
      unit: GlucoseUnit.mmolL,
      yScale: yScale,
    );
    final wide = AgpChartGeometry(
      size: const Size(430, 180),
      unit: GlucoseUnit.mmolL,
      yScale: yScale,
    );

    expect(narrow.strokeScale, closeTo(320 / 350, 0.001));
    expect(design.strokeScale, 1);
    expect(wide.strokeScale, 1);
  });

  test('viewport follows AGP data and target range instead of fixed SVG y', () {
    const calmSlots = [
      AnalysisAgpSlot(
        minuteOfDay: 0,
        p10: 5,
        p25: 6,
        p50: 7,
        p75: 8,
        p90: 9,
      ),
    ];
    const wideSlots = [
      AnalysisAgpSlot(
        minuteOfDay: 0,
        p10: 2,
        p25: 4,
        p50: 7,
        p75: 11,
        p90: 15,
      ),
    ];

    final calm = AgpChartViewport.fromSlots(
      slots: calmSlots,
      low: 3.9,
      high: 10,
    );
    final wide = AgpChartViewport.fromSlots(
      slots: wideSlots,
      low: 3.9,
      high: 10,
    );

    expect(wide.maxMmol, greaterThan(calm.maxMmol));
    expect(wide.minMmol, lessThanOrEqualTo(calm.minMmol));
    expect(calm.referenceLabelsMmol, contains(3.9));
    expect(calm.referenceLabelsMmol, contains(10));
  });
}
