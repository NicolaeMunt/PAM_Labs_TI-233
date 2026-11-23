import '../entities/appointment_details.dart';
import '../entities/home_feed.dart';

/// What the app needs from its data source. Implemented in the Data layer.
///
/// Both methods throw a `Failure` (see core/error/failures.dart) when
/// something goes wrong.
abstract interface class HealthRepository {
  Future<HomeFeed> getHomeFeed();

  Future<AppointmentDetails> getAppointmentDetails();
}
