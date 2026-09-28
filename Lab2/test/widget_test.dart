import 'package:flutter_test/flutter_test.dart';

import 'package:lab2/main.dart';

void main() {
  testWidgets('home screen renders and opens appointment details', (
    tester,
  ) async {
    await tester.pumpWidget(const HealthApp());

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Health Services'), findsOneWidget);
    expect(find.text('Nearby Doctor'), findsOneWidget);

    await tester.tap(find.text('22 October, 2023'));
    await tester.pumpAndSettle();

    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Book an Appointment'), findsOneWidget);

    await tester.tap(find.text('Mon 5'));
    await tester.tap(find.text('Book an Appointment'));
    await tester.pump();

    expect(find.textContaining('Mon 5 at 11.00 AM'), findsOneWidget);
  });
}
