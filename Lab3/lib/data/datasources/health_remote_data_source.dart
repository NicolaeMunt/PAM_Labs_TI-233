import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_config.dart';
import '../models/appointment_details_model.dart';
import '../models/home_feed_model.dart';

/// Talks to the REST API and returns DTOs.
abstract interface class HealthRemoteDataSource {
  Future<HomeFeedModel> getHomeFeed();

  Future<AppointmentDetailsModel> getAppointmentDetails();
}

class HealthRemoteDataSourceImpl implements HealthRemoteDataSource {
  final ApiClient _api;

  const HealthRemoteDataSourceImpl(this._api);

  @override
  Future<HomeFeedModel> getHomeFeed() async {
    final json = await _api.getJson(ApiConfig.feedPath);
    return _parse(() => HomeFeedModel.fromJson(json));
  }

  @override
  Future<AppointmentDetailsModel> getAppointmentDetails() async {
    final json = await _api.getJson(ApiConfig.feedDetailsPath);
    return _parse(() => AppointmentDetailsModel.fromJson(json));
  }

  /// Deserialization fails with TypeError (wrong type) or a cast error
  /// (missing field) when the JSON shape changes. Report it as parsing.
  T _parse<T>(T Function() fromJson) {
    try {
      return fromJson();
    } on TypeError catch (e) {
      throw ParsingException(e);
    }
  }
}
