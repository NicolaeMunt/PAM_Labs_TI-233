import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/domain/entities/doctor.dart';
import 'package:lab3/domain/usecases/filter_doctors.dart';

Doctor doc(String id, String name, String specialty, String distance) => Doctor(
  id: id,
  name: name,
  specialty: specialty,
  distanceLabel: distance,
  avatarUrl: '',
);

void main() {
  const filter = FilterDoctors();
  final doctors = [
    doc('a', 'Dr. Anna Bell', 'Dental Specialist', 'Oak Rd - 1.5KM from you'),
    doc('b', 'Dr. Carl Dorn', 'Ophthalmologist', 'Elm St - 300M from you'),
    doc('c', 'Dr. Bob Evans', 'General Practitioner', 'Pine - 900M from you'),
  ];
  List<String> ids(List<Doctor> list) => list.map((d) => d.id).toList();

  test('default: everyone, nearest first', () {
    expect(ids(filter(doctors: doctors)), ['b', 'c', 'a']);
  });

  test('search matches name, specialty and address, ignoring case', () {
    expect(ids(filter(doctors: doctors, query: 'ANNA')), ['a']);
    expect(ids(filter(doctors: doctors, query: 'ophthal')), ['b']);
    expect(ids(filter(doctors: doctors, query: ' pine ')), ['c']);
    expect(filter(doctors: doctors, query: 'zzz'), isEmpty);
  });

  test('service filter uses the specialty', () {
    expect(ids(filter(doctors: doctors, serviceId: 'tooth')), ['a']);
    expect(ids(filter(doctors: doctors, serviceId: 'eye')), ['b']);
    expect(filter(doctors: doctors, serviceId: 'ear'), isEmpty);
  });

  test('favorites only', () {
    expect(
      ids(
        filter(doctors: doctors, favoritesOnly: true, favoriteIds: {'a', 'c'}),
      ),
      ['c', 'a'],
    );
  });

  test('sorting by name both ways', () {
    expect(ids(filter(doctors: doctors, sort: DoctorSort.nameAsc)), [
      'a',
      'c',
      'b',
    ]);
    expect(ids(filter(doctors: doctors, sort: DoctorSort.nameDesc)), [
      'b',
      'c',
      'a',
    ]);
  });

  test('distance parsing', () {
    expect(Doctor.parseDistanceMeters('x - 500M from you'), 500);
    expect(Doctor.parseDistanceMeters('x - 1.2KM from you'), 1200);
    expect(Doctor.parseDistanceMeters('nowhere'), double.infinity);
  });

  test('service from specialty', () {
    expect(doc('x', 'X', 'Audiologist', '').serviceId, 'ear');
    expect(doc('x', 'X', 'ENT Specialist', '').serviceId, 'ear');
    expect(doc('x', 'X', 'Pulmonologist', '').serviceId, 'lungs');
    expect(doc('x', 'X', 'Child Specialist', '').serviceId, isNull);
  });
}
