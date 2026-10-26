import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab3/logic/booking/booking_cubit.dart';

import 'helpers.dart';

void main() {
  final details = sampleData().appointmentDetails;

  test('starts with the slots marked selected in the JSON', () {
    final cubit = BookingCubit(details);
    expect(cubit.state.hourId, '11am');
    expect(cubit.state.dateId, 'sun-4');
    expect(cubit.state.canBook, isTrue);
    cubit.close();
  });

  blocTest<BookingCubit, BookingState>(
    'selecting slots updates state',
    build: () => BookingCubit(details),
    act: (c) => c
      ..selectHour('10am')
      ..selectDate('mon-5'),
    expect: () => const [
      BookingState(hourId: '10am', dateId: 'sun-4'),
      BookingState(hourId: '10am', dateId: 'mon-5'),
    ],
  );

  blocTest<BookingCubit, BookingState>(
    'book goes submitting -> booked',
    build: () => BookingCubit(details, submitDelay: Duration.zero),
    act: (c) => c.book(),
    expect: () => const [
      BookingState(
        hourId: '11am',
        dateId: 'sun-4',
        status: BookingStatus.submitting,
      ),
      BookingState(
        hourId: '11am',
        dateId: 'sun-4',
        status: BookingStatus.booked,
      ),
    ],
  );
}
