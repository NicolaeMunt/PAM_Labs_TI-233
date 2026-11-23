import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lab3/app.dart';
import 'package:lab3/injection.dart';
import 'package:lab3/presentation/screens/doctor_details_screen.dart';
import 'package:lab3/presentation/widgets/doctor_card.dart';

import '../helpers.dart';

// These tests run the whole app through all three layers
// (UI → Cubit → use case → repository → data source → HTTP) against a fake
// HTTP server that returns the real API responses.
void main() {
  Future<void> pumpApp(WidgetTester tester, http.Client client) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      HealthApp(dependencies: AppDependencies.live(client: client)),
    );
  }

  testWidgets('Loading, then the home screen from GET /feed', (tester) async {
    final response = Completer<http.Response>();
    await pumpApp(tester, fakeApi(onFeed: () => response.future));
    await tester.pump();
    expect(find.text('Loading doctors…'), findsOneWidget);

    response.complete(await okJson(fixtureJson('feed.json')));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Jonathan'), findsOneWidget);
    expect(find.text('Search something'), findsOneWidget);
    expect(find.text('22 October, 2023'), findsOneWidget);
    expect(find.byType(DoctorCard), findsNWidgets(2));
    expect(find.text('Dr. Sonja Litel'), findsOneWidget);
  });

  testWidgets('server error shows Error, Try again recovers', (tester) async {
    var calls = 0;
    await pumpApp(
      tester,
      fakeApi(
        onFeed: () async => ++calls == 1
            ? http.Response('down', 503)
            : await okJson(fixtureJson('feed.json')),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Couldn\'t load data'), findsOneWidget);
    expect(find.textContaining('503'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.byType(DoctorCard), findsNWidgets(2));
  });

  testWidgets('search with no match shows Empty', (tester) async {
    await pumpApp(tester, fakeApi());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'nobody');
    await tester.pumpAndSettle();
    expect(find.text('No doctors found'), findsOneWidget);
  });

  testWidgets('doctor details load from GET /feed/details', (tester) async {
    final calls = <Uri>[];
    await pumpApp(tester, fakeApi(log: calls));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Dr. Sonja Litel'));
    await tester.pumpAndSettle();

    expect(find.byType(DoctorDetailsScreen), findsOneWidget);
    // Only API calls (icons are downloaded through the same client).
    final apiCalls = calls.where((u) => u.host == 'test-api-jlbn.onrender.com');
    expect(apiCalls.map((u) => u.path), [
      endsWith('/feed'),
      endsWith('/feed/details'),
    ]);
    expect(find.text('Dental Specialist'), findsOneWidget);
    expect(find.text(r'$120.00'), findsOneWidget);
    expect(find.text('11.00 AM'), findsOneWidget);

    // Favorite from details shows up on the home list.
    await tester.tap(find.byTooltip('Add to favorites'));
    await tester.pump();
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.text('Favorites (1)'), findsOneWidget);
  });

  testWidgets('appointment card opens the API appointment, books it', (
    tester,
  ) async {
    await pumpApp(tester, fakeApi());
    await tester.pumpAndSettle();

    await tester.tap(find.text('22 October, 2023'));
    await tester.pumpAndSettle();
    expect(find.text('Dr.Upul'), findsOneWidget);
    expect(find.text('Denteeth'), findsOneWidget);

    await tester.tap(find.text('Mon 5'));
    await tester.pump();
    await tester.tap(find.text('Book an Appointment'));
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pump();
    expect(
      find.text('Appointment booked on Mon 5 at 11.00 AM'),
      findsOneWidget,
    );
  });

  testWidgets('details error shows Error with retry', (tester) async {
    var calls = 0;
    await pumpApp(
      tester,
      fakeApi(
        onDetails: () async => ++calls == 1
            ? throw http.ClientException('offline')
            : await okJson(fixtureJson('feed_details.json')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dr. Sonja Litel'));
    await tester.pumpAndSettle();

    expect(find.text('Couldn\'t load data'), findsOneWidget);
    await tester.tap(find.text('Try again'));
    await tester.pumpAndSettle();
    expect(find.text(r'$120.00'), findsOneWidget);
  });
}
