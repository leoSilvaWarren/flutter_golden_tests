import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:golden_tests/main.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> theAppIsRendered(WidgetTester tester) async {
  await loadAppFonts();
  await tester.pumpWidgetBuilder(const MyApp());
}

Future<void> deviceBuilder(WidgetTester tester) async {
  await loadAppFonts();
  final builder = DeviceBuilder()
    ..overrideDevicesForAllScenarios(devices: [
      Device.iphone11,
      const Device(size: Size(420, 750), name: 'Android 6'),
      Device.phone,
      const Device(size: Size(400, 600), name: 'Android 5')
  ])
    ..addScenario(widget: const MyApp());
  await tester.pumpDeviceBuilder(builder);
}

void main() {
  testWidgets('WHEN load initial page THEN counter should not 1', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('1'), findsNothing);
  });

  testWidgets('WHEN load initial page THEN counter must be 0', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('WHEN tap the "+" page THEN counter should not 0', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('0'), findsNothing);
  });

  testWidgets('WHEN tap the "+" page THEN counter must be 1', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
  });

  testGoldens("WHEN render app THEN screenshot verified device", (WidgetTester tester) async {
    await deviceBuilder(tester);
    await screenMatchesGolden(tester, 'device_counter');
  });

  testGoldens("WHEN render app THEN screenshot verified snapshot", (WidgetTester tester) async {
     await theAppIsRendered(tester);
     await screenMatchesGolden(tester, 'snapshot_counter');
  });

}
