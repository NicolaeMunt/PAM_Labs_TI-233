import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/error/failures.dart';
import '../../../domain/entities/appointment_details.dart';
import '../../../domain/usecases/get_appointment_details.dart';

enum DetailsStatus { loading, success, error }

enum BookingStatus { idle, submitting, booked }

class DetailsState extends Equatable {
  final DetailsStatus status;

  /// Data from GET /feed/details. Null until it loads.
  final AppointmentDetails? details;
  final String? hourId;
  final String? dateId;
  final BookingStatus booking;
  final String? errorMessage;

  const DetailsState({
    this.status = DetailsStatus.loading,
    this.details,
    this.hourId,
    this.dateId,
    this.booking = BookingStatus.idle,
    this.errorMessage,
  });

  bool get canBook =>
      details != null &&
      details!.bookEnabled &&
      hourId != null &&
      dateId != null &&
      booking != BookingStatus.submitting;

  DetailsState copyWith({
    DetailsStatus? status,
    AppointmentDetails? details,
    String? hourId,
    String? dateId,
    BookingStatus? booking,
    String? Function()? errorMessage,
  }) => DetailsState(
    status: status ?? this.status,
    details: details ?? this.details,
    hourId: hourId ?? this.hourId,
    dateId: dateId ?? this.dateId,
    booking: booking ?? this.booking,
    errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    details,
    hourId,
    dateId,
    booking,
    errorMessage,
  ];
}

/// Details screen: loads GET /feed/details, then handles slot selection
/// and booking.
class DetailsCubit extends Cubit<DetailsState> {
  final GetAppointmentDetails _getDetails;
  final Duration bookingDelay;

  DetailsCubit({
    required GetAppointmentDetails getAppointmentDetails,
    this.bookingDelay = const Duration(milliseconds: 1200),
  }) : _getDetails = getAppointmentDetails,
       super(const DetailsState());

  Future<void> load() async {
    emit(
      state.copyWith(status: DetailsStatus.loading, errorMessage: () => null),
    );
    try {
      final details = await _getDetails();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: DetailsStatus.success,
          details: details,
          // Keep the user's choice on retry; otherwise use the API's default.
          hourId: state.hourId ?? details.workingHours.initialSelectionId,
          dateId: state.dateId ?? details.dates.initialSelectionId,
        ),
      );
    } on Failure catch (f) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: DetailsStatus.error,
          errorMessage: () => f.message,
        ),
      );
    }
  }

  void selectHour(String id) =>
      emit(state.copyWith(hourId: id, booking: BookingStatus.idle));

  void selectDate(String id) =>
      emit(state.copyWith(dateId: id, booking: BookingStatus.idle));

  /// The lab API is read-only (it has no POST endpoint for bookings),
  /// so booking is simulated with a delay.
  Future<void> book() async {
    if (!state.canBook) return;
    emit(state.copyWith(booking: BookingStatus.submitting));
    await Future<void>.delayed(bookingDelay);
    if (isClosed) return;
    emit(state.copyWith(booking: BookingStatus.booked));
  }
}
