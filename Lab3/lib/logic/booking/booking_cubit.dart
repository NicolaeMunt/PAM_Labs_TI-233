import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/appointment_details.dart';

enum BookingStatus { idle, submitting, booked }

class BookingState extends Equatable {
  final String? hourId;
  final String? dateId;
  final BookingStatus status;

  const BookingState({
    this.hourId,
    this.dateId,
    this.status = BookingStatus.idle,
  });

  bool get canBook =>
      hourId != null && dateId != null && status != BookingStatus.submitting;

  BookingState copyWith({
    String? hourId,
    String? dateId,
    BookingStatus? status,
  }) => BookingState(
    hourId: hourId ?? this.hourId,
    dateId: dateId ?? this.dateId,
    status: status ?? this.status,
  );

  @override
  List<Object?> get props => [hourId, dateId, status];
}

/// Slot selection and the (simulated) booking request on the details screen.
class BookingCubit extends Cubit<BookingState> {
  final Duration submitDelay;

  BookingCubit(
    AppointmentDetails details, {
    this.submitDelay = const Duration(milliseconds: 1200),
  }) : super(
         BookingState(
           hourId: details.workingHours.initialSelectionId,
           dateId: details.dates.initialSelectionId,
         ),
       );

  void selectHour(String id) =>
      emit(state.copyWith(hourId: id, status: BookingStatus.idle));

  void selectDate(String id) =>
      emit(state.copyWith(dateId: id, status: BookingStatus.idle));

  Future<void> book() async {
    if (!state.canBook) return;
    emit(state.copyWith(status: BookingStatus.submitting));
    await Future<void>.delayed(submitDelay);
    if (isClosed) return;
    emit(state.copyWith(status: BookingStatus.booked));
  }
}
