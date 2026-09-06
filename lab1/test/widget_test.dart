import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lab1/main.dart';

void main() {
  testWidgets('Calculates average fuel consumption', (WidgetTester tester) async {
    await tester.pumpWidget(const FuelApp());

    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));

    await tester.enterText(textFields.at(0), '400');
    await tester.enterText(textFields.at(1), '32');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pump();

    // 32 L / 400 km * 100 = 8.00 L/100km
    expect(find.text('8.00 L/100km'), findsOneWidget);
    expect(find.text('Average'), findsOneWidget);
  });

  testWidgets('Shows an error when distance is zero', (WidgetTester tester) async {
    await tester.pumpWidget(const FuelApp());

    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), '0');
    await tester.enterText(textFields.at(1), '10');

    await tester.tap(find.widgetWithText(ElevatedButton, 'Calculate'));
    await tester.pump();

    expect(find.text('Distance must be greater than zero.'), findsOneWidget);
  });
}
