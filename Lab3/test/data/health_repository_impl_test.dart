import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:lab3/core/error/failures.dart';
import 'package:lab3/core/network/api_client.dart';
import 'package:lab3/data/datasources/health_remote_data_source.dart';
import 'package:lab3/data/repositories/health_repository_impl.dart';

import '../helpers.dart';

void main() {
  HealthRepositoryImpl repo({
    Future<http.Response> Function()? onFeed,
    Future<http.Response> Function()? onDetails,
    List<Uri>? log,
  }) => HealthRepositoryImpl(
    HealthRemoteDataSourceImpl(
      ApiClient(
        fakeApi(onFeed: onFeed, onDetails: onDetails, log: log),
        baseUrl: 'https://api.test/lab2026/v2',
      ),
    ),
  );

  test('getHomeFeed calls /feed and returns entities', () async {
    final calls = <Uri>[];
    final feed = await repo(log: calls).getHomeFeed();
    expect(calls.single.path, '/lab2026/v2/feed');
    expect(feed.doctors, hasLength(2));
    expect(feed.user.name, 'Jonathan');
  });

  test('getAppointmentDetails calls /feed/details', () async {
    final calls = <Uri>[];
    final details = await repo(log: calls).getAppointmentDetails();
    expect(calls.single.path, '/lab2026/v2/feed/details');
    expect(details.doctor.name, 'Dr.Upul');
  });

  test('HTTP 500 -> ServerFailure', () async {
    final r = repo(onFeed: () async => http.Response('oops', 500));
    await expectLater(
      r.getHomeFeed(),
      throwsA(isA<ServerFailure>().having((f) => f.statusCode, 'code', 500)),
    );
  });

  test('no connection -> NetworkFailure', () async {
    final r = repo(onFeed: () => throw http.ClientException('offline'));
    await expectLater(r.getHomeFeed(), throwsA(isA<NetworkFailure>()));
  });

  test('blocked request in a browser -> NetworkFailure that says so', () async {
    final r = repo(
      onDetails: () => throw http.ClientException('XMLHttpRequest error.'),
    );
    await expectLater(
      r.getAppointmentDetails(),
      throwsA(
        isA<NetworkFailure>().having(
          (f) => f.message,
          'message',
          contains('browser blocked'),
        ),
      ),
    );
  });

  test('missing required field -> ParsingFailure', () async {
    final broken = fixtureJson('feed.json')..remove('user');
    final r = repo(onFeed: () => okJson(broken));
    await expectLater(r.getHomeFeed(), throwsA(isA<ParsingFailure>()));
  });

  test('wrong field type -> ParsingFailure', () async {
    final broken = fixtureJson('feed_details.json')..['payment'] = 'free';
    final r = repo(onDetails: () => okJson(broken));
    await expectLater(
      r.getAppointmentDetails(),
      throwsA(isA<ParsingFailure>()),
    );
  });
}
