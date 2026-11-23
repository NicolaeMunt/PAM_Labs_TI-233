import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/data/models/appointment_details_model.dart';
import 'package:lab3/data/models/home_feed_model.dart';

import '../helpers.dart';

void main() {
  group('HomeFeedModel (GET /feed)', () {
    final json = fixtureJson('feed.json');

    test('fromJson then toJson gives back the same JSON', () {
      expect(HomeFeedModel.fromJson(json).toJson(), json);
    });

    test('toEntity maps every field', () {
      final feed = HomeFeedModel.fromJson(json).toEntity();
      expect(feed.user.greeting, 'Hi, Jonathan');
      expect(feed.user.subtitle, 'May you always be healthy!');
      expect(feed.hasUnreadNotifications, isTrue);
      expect(feed.searchHint, 'Search something');
      expect(feed.appointment.doctorName, 'Dr. Richar Kandowen');
      expect(feed.appointment.time, '08:00 AM - 10.30 AM');
      expect(feed.services.map((s) => s.id), ['tooth', 'eye', 'lungs', 'ear']);
      expect(feed.doctors.map((d) => d.id), ['doctor-001', 'doctor-002']);

      final sonja = feed.doctors[1];
      expect(sonja.name, 'Dr. Sonja Litel');
      expect(sonja.address, '950 Sigrid Port');
      expect(sonja.distanceMeters, 753);
      expect(sonja.serviceId, 'tooth');
    });

    test('missing optional fields fall back to defaults', () {
      final minimal = {
        'user': {'name': 'A', 'greeting': 'Hi'},
        'notifications': <String, dynamic>{},
        'search': <String, dynamic>{},
        'appointment': {
          'title': 'T',
          'date': 'D',
          'time': 'H',
          'doctor': {'name': 'Dr. X'},
        },
      };
      final feed = HomeFeedModel.fromJson(minimal).toEntity();
      expect(feed.doctors, isEmpty);
      expect(feed.services, isEmpty);
      expect(feed.hasUnreadNotifications, isFalse);
      expect(feed.user.avatarUrl, '');
    });
  });

  group('AppointmentDetailsModel (GET /feed/details)', () {
    final json = fixtureJson('feed_details.json');

    test('fromJson then toJson gives back the same JSON', () {
      expect(AppointmentDetailsModel.fromJson(json).toJson(), json);
    });

    test('toEntity maps every field', () {
      final d = AppointmentDetailsModel.fromJson(json).toEntity();
      expect(d.title, 'Appointment');
      expect(d.doctor.name, 'Dr.Upul');
      expect(d.doctor.clinic, 'Denteeth');
      expect(d.doctor.canVideoCall, isTrue);
      expect(d.paymentAmount, 120.0);
      expect(d.formattedPrice, r'$120.00');
      expect(d.description, startsWith('Worem ipsum'));
      expect(d.workingHours.slots.map((s) => s.label), [
        '10.00 AM',
        '11.00 AM',
        '12.00 PM',
      ]);
      expect(d.workingHours.initialSelectionId, '11am');
      expect(d.dates.initialSelectionId, 'sun-4');
      expect(d.bookLabel, 'Book an Appointment');
      expect(d.bookEnabled, isTrue);
    });

    test('an integer amount is read as double', () {
      final copy = fixtureJson('feed_details.json');
      (copy['payment'] as Map<String, dynamic>)['amount'] = 95;
      expect(AppointmentDetailsModel.fromJson(copy).payment.amount, 95.0);
    });
  });
}
