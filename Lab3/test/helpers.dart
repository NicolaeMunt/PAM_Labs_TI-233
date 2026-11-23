import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab3/core/network/api_config.dart';

/// Real responses saved from the v2 API.
String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Map<String, dynamic> fixtureJson(String name) =>
    jsonDecode(fixture(name)) as Map<String, dynamic>;

/// Fake HTTP server that answers like the real API, from the fixtures.
/// [onFeed] / [onDetails] can override a response.
MockClient fakeApi({
  Future<http.Response> Function()? onFeed,
  Future<http.Response> Function()? onDetails,
  List<Uri>? log,
}) {
  return MockClient((request) async {
    log?.add(request.url);
    final path = request.url.path;
    if (path.endsWith(ApiConfig.feedDetailsPath)) {
      return onDetails?.call() ?? _ok(fixture('feed_details.json'));
    }
    if (path.endsWith(ApiConfig.feedPath)) {
      return onFeed?.call() ?? _ok(fixture('feed.json'));
    }
    return http.Response('Page not found', 404);
  });
}

http.Response _ok(String body) => http.Response.bytes(
  utf8.encode(body),
  200,
  headers: {'content-type': 'application/json'},
);

Future<http.Response> okJson(Object json) async => _ok(jsonEncode(json));
