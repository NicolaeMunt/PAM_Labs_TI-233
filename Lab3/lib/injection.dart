import 'package:http/http.dart' as http;

import 'core/network/api_client.dart';
import 'data/datasources/health_remote_data_source.dart';
import 'data/repositories/health_repository_impl.dart';
import 'domain/repositories/health_repository.dart';
import 'domain/usecases/get_appointment_details.dart';
import 'domain/usecases/get_home_feed.dart';

/// Builds the object graph once, from the outside in:
/// http.Client → ApiClient → RemoteDataSource → Repository → Use cases.
/// Each layer only receives the one below it.
class AppDependencies {
  final GetHomeFeed getHomeFeed;
  final GetAppointmentDetails getAppointmentDetails;

  /// One HTTP client for the whole app (API calls and SVG icons).
  final http.Client httpClient;

  const AppDependencies({
    required this.getHomeFeed,
    required this.getAppointmentDetails,
    required this.httpClient,
  });

  factory AppDependencies.fromRepository(
    HealthRepository repository,
    http.Client httpClient,
  ) => AppDependencies(
    getHomeFeed: GetHomeFeed(repository),
    getAppointmentDetails: GetAppointmentDetails(repository),
    httpClient: httpClient,
  );

  /// The real app: talks to the REST API over HTTP.
  /// Tests pass a fake [client] that answers like the server.
  factory AppDependencies.live({http.Client? client}) {
    final httpClient = client ?? http.Client();
    final remote = HealthRemoteDataSourceImpl(ApiClient(httpClient));
    return AppDependencies.fromRepository(
      HealthRepositoryImpl(remote),
      httpClient,
    );
  }
}
