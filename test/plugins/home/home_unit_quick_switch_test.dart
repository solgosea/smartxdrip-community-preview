import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugins/home/widgets/home_unit_quick_switch.dart';

void main() {
  testWidgets('home unit quick switch emits selected unit', (tester) async {
    GlucoseUnit? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: HomeUnitQuickSwitch(
              unit: GlucoseUnit.mmolL,
              onChanged: (unit) => selected = unit,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('mg/dL'));
    await tester.pumpAndSettle();

    expect(selected, GlucoseUnit.mgDl);
  });
}
