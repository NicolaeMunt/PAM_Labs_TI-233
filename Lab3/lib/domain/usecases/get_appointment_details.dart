import '../entities/appointment_details.dart';
import '../repositories/health_repository.dart';

/// Loads the content of the appointment details screen.
class GetAppointmentDetails {
  final HealthRepository _repository;

  const GetAppointmentDetails(this._repository);

  Future<AppointmentDetails> call() => _repository.getAppointmentDetails();
}
