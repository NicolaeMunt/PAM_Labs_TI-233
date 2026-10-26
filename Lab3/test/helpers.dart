import 'dart:async';

import 'package:lab3/data/models/appointment_details.dart';
import 'package:lab3/data/models/doctor.dart';
import 'package:lab3/data/models/health_data.dart';
import 'package:lab3/data/models/home_models.dart';
import 'package:lab3/data/repositories/health_repository.dart';

/// Repository whose answer each test controls.
class FakeHealthRepository implements HealthRepository {
  final List<FutureOr<HealthData> Function()> _responses;
  int calls = 0;

  FakeHealthRepository(this._responses);

  factory FakeHealthRepository.data(HealthData data) =>
      FakeHealthRepository([() => data]);

  factory FakeHealthRepository.failing([String message = 'boom']) =>
      FakeHealthRepository([() => throw HealthDataException(message)]);

  @override
  Future<HealthData> loadHealthData() async {
    final i = calls < _responses.length ? calls : _responses.length - 1;
    calls++;
    return _responses[i]();
  }
}

Doctor doctor(
  String id,
  String name, {
  String specialty = 'General',
  String serviceId = 'general',
  String distance = '1 Main St - 500M from you',
  double rating = 4.5,
  double price = 100,
  bool isFavorite = false,
}) => Doctor(
  id: id,
  name: name,
  specialty: specialty,
  distanceLabel: distance,
  address: distance.split(' - ').first,
  distanceMeters: Doctor.parseDistanceMeters(distance),
  avatarUrl: '',
  serviceId: serviceId,
  rating: rating,
  price: price,
  isFavorite: isFavorite,
  reviews: 10,
  experienceYears: 5,
);

final sampleDoctors = [
  doctor(
    'a',
    'Dr. Anna Bell',
    specialty: 'Dentist',
    serviceId: 'tooth',
    distance: 'Oak Rd - 1.5KM from you',
    rating: 4.9,
    price: 150,
    isFavorite: true,
  ),
  doctor(
    'b',
    'Dr. Carl Dorn',
    specialty: 'Eye Doctor',
    serviceId: 'eye',
    distance: 'Elm St - 300M from you',
    rating: 4.2,
    price: 80,
  ),
  doctor(
    'c',
    'Dr. Bob Evans',
    specialty: 'Dental Surgeon',
    serviceId: 'tooth',
    distance: 'Pine Ave - 900M from you',
    rating: 4.6,
    price: 120,
  ),
];

HealthData sampleData({List<Doctor>? doctors}) => HealthData(
  user: const UserProfile(
    name: 'Jonathan',
    greeting: 'Hi, Jonathan',
    subtitle: 'May you always be healthy!',
    avatarUrl: '',
  ),
  hasUnreadNotifications: true,
  searchHint: 'Search something',
  appointment: const UpcomingAppointment(
    title: 'Appointment',
    date: '22 October, 2023',
    time: '08:00 AM - 10.30 AM',
    doctorName: 'Dr. Anna Bell',
    doctorSpecialty: 'Dentist',
    doctorAvatarUrl: '',
  ),
  services: const [
    HealthService(id: 'tooth', name: 'Tooth', iconUrl: ''),
    HealthService(id: 'eye', name: 'Eye', iconUrl: ''),
  ],
  doctors: doctors ?? sampleDoctors,
  appointmentDetails: const AppointmentDetails(
    title: 'Appointment',
    paymentLabel: 'Payment',
    paymentAmount: 120,
    currency: 'USD',
    detailsTitle: 'Details',
    description: 'Lorem ipsum',
    workingHours: SlotGroup(
      title: 'Working Hours',
      slots: [
        TimeSlot(id: '10am', label: '10.00 AM'),
        TimeSlot(id: '11am', label: '11.00 AM', selected: true),
      ],
    ),
    dates: SlotGroup(
      title: 'Date',
      slots: [
        TimeSlot(id: 'sun-4', label: 'Sun 4', selected: true),
        TimeSlot(id: 'mon-5', label: 'Mon 5'),
      ],
    ),
    bookLabel: 'Book an Appointment',
  ),
);
