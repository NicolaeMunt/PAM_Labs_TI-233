import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/app.dart';
import 'package:lab3/data/models/health_data.dart';
import 'package:lab3/presentation/screens/doctor_details_screen.dart';
import 'package:lab3/presentation/widgets/doctor_card.dart';

import 'helpers.dart';

void main() {
  Future<void> pumpApp(WidgetTester tester, FakeHealthRepository repo) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(HealthApp(repository: repo));
  }

  testWidgets('shows Loading, then the doctor list', (tester) async {
    final completer = Completer<HealthData>();
    await pumpApp(tester, FakeHealthRepository([() => completer.future]));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Loading doctors…'), findsOneWidget);

    completer.complete(sampleData());
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.byType(DoctorCard), findsNWidgets(3));
    expect(find.text('3 of 3'), findsOneWidget);
  });

  testWidgets('Error state retries', (tester) async {
    final repo = FakeHealthRepository([
      () => throw Exception('offline'),
      () => sampleData(),
    ]);
    await pumpApp(tester, repo);
    await tester.pumpAndSettle();

    expect(find.text('Couldn\'t load data'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();

    expect(find.byType(DoctorCard), findsNWidgets(3));
    expect(repo.calls, 2);
  });

  testWidgets('search to Empty state, then clear filters', (tester) async {
    await pumpApp(tester, FakeHealthRepository.data(sampleData()));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'carl');
    await tester.pumpAndSettle();
    expect(find.byType(DoctorCard), findsOneWidget);
    expect(find.text('Dr. Carl Dorn'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nobody');
    await tester.pumpAndSettle();
    expect(find.byType(DoctorCard), findsNothing);
    expect(find.text('No doctors found'), findsOneWidget);

    final clear = find.widgetWithText(OutlinedButton, 'Clear filters');
    await tester.ensureVisible(clear);
    await tester.pumpAndSettle();
    await tester.tap(clear);
    await tester.pumpAndSettle();
    expect(find.byType(DoctorCard), findsNWidgets(3));
    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.controller!.text, isEmpty);
  });

  testWidgets('tapping a health service filters the list', (tester) async {
    await pumpApp(tester, FakeHealthRepository.data(sampleData()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Eye').first);
    await tester.pumpAndSettle();
    expect(find.byType(DoctorCard), findsOneWidget);
    expect(find.text('1 of 3'), findsOneWidget);
  });

  testWidgets('favorite on details screen shows up on home', (tester) async {
    await pumpApp(tester, FakeHealthRepository.data(sampleData()));
    await tester.pumpAndSettle();
    expect(find.text('Favorites (1)'), findsOneWidget);

    await tester.tap(find.text('Dr. Carl Dorn'));
    await tester.pumpAndSettle();
    expect(find.byType(DoctorDetailsScreen), findsOneWidget);
    expect(find.text('Eye Doctor'), findsOneWidget);
    expect(find.text(r'$80.00'), findsOneWidget);

    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Remove from favorites'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Favorites (2)'), findsOneWidget);
  });

  testWidgets('booking shows a confirmation', (tester) async {
    await pumpApp(tester, FakeHealthRepository.data(sampleData()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dr. Anna Bell').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mon 5'));
    await tester.pump();
    await tester.tap(find.text('Book an Appointment'));
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();

    expect(
      find.text('Appointment booked with Dr. Anna Bell on Mon 5 at 11.00 AM'),
      findsOneWidget,
    );
  });
}
