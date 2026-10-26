import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/data/models/doctor.dart';
import 'package:lab3/data/models/health_data.dart';

void main() {
  group('health_data.json', () {
    late HealthData data;

    setUpAll(() {
      final raw = File('assets/data/health_data.json').readAsStringSync();
      data = HealthData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    });

    test('parses the home screen', () {
      expect(data.user.greeting, 'Hi, Jonathan');
      expect(data.hasUnreadNotifications, isTrue);
      expect(data.searchHint, 'Search something');
      expect(data.appointment.doctorName, 'Dr. Richar Kandowen');
      expect(data.services.map((s) => s.id), ['tooth', 'eye', 'lungs', 'ear']);
      expect(data.doctors, hasLength(10));
      expect(data.doctors.map((d) => d.id).toSet(), hasLength(10));
    });

    test('every doctor has a known service or "general"', () {
      final ids = {...data.services.map((s) => s.id), 'general'};
      for (final d in data.doctors) {
        expect(ids, contains(d.serviceId), reason: d.name);
        expect(d.distanceMeters, isNot(double.infinity), reason: d.name);
      }
    });

    test('appointment card doctor exists in the list', () {
      expect(data.doctorNamed(data.appointment.doctorName), isNotNull);
    });

    test('parses appointment details', () {
      final details = data.appointmentDetails;
      expect(details.paymentAmount, 120);
      expect(details.formatPrice(120), r'$120.00');
      expect(details.workingHours.initialSelectionId, '11am');
      expect(details.dates.initialSelectionId, 'sun-4');
      expect(details.bookLabel, 'Book an Appointment');
    });
  });

  group('Doctor.parseDistanceMeters', () {
    test('reads meters and kilometers', () {
      expect(Doctor.parseDistanceMeters('3167 Durgan - 500M from you'), 500);
      expect(Doctor.parseDistanceMeters('Lotus Ave - 1.2KM from you'), 1200);
      expect(Doctor.parseDistanceMeters('x - 2,5 km from you'), 2500);
    });

    test('returns infinity when missing', () {
      expect(Doctor.parseDistanceMeters('Somewhere'), double.infinity);
    });
  });
}
