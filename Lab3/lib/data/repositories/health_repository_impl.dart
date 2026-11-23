import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/appointment_details.dart';
import '../../domain/entities/home_feed.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/health_remote_data_source.dart';

/// Domain repository backed by the REST API.
/// Turns DTOs into entities and Data exceptions into Domain failures.
class HealthRepositoryImpl implements HealthRepository {
  final HealthRemoteDataSource _remote;

  const HealthRepositoryImpl(this._remote);

  @override
  Future<HomeFeed> getHomeFeed() =>
      _guard(() async => (await _remote.getHomeFeed()).toEntity());

  @override
  Future<AppointmentDetails> getAppointmentDetails() =>
      _guard(() async => (await _remote.getAppointmentDetails()).toEntity());

  Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on NetworkException catch (e) {
      throw NetworkFailure(_networkMessage(e.message));
    } on ServerException catch (e) {
      throw ServerFailure(e.statusCode);
    } on ParsingException {
      throw const ParsingFailure();
    }
  }

  /// In a browser, a blocked request (CORS) shows up as "XMLHttpRequest
  /// error". Give the user a plain explanation instead.
  String _networkMessage(String raw) {
    if (raw.contains('XMLHttpRequest') || raw.contains('Failed to fetch')) {
      return 'The browser blocked the request to the server. '
          'Run the app on a phone or emulator.';
    }
    if (raw.contains('too long')) return raw;
    return const NetworkFailure().message;
  }
}
