import '../entities/home_feed.dart';
import '../repositories/health_repository.dart';

/// Loads the home screen data.
class GetHomeFeed {
  final HealthRepository _repository;

  const GetHomeFeed(this._repository);

  Future<HomeFeed> call() => _repository.getHomeFeed();
}
