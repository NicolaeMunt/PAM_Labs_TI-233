import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:lab3/core/error/exceptions.dart';
import 'package:lab3/core/network/api_client.dart';

void main() {
  ApiClient client(MockClientHandler handler, {Duration? timeout}) => ApiClient(
    MockClient(handler),
    baseUrl: 'https://api.test/v2',
    timeout: timeout ?? const Duration(seconds: 5),
  );

  test('sends GET to baseUrl + path and decodes the body', () async {
    late http.Request sent;
    final api = client((req) async {
      sent = req;
      return http.Response.bytes(utf8.encode('{"greeting":"Let’s go"}'), 200);
    });

    final json = await api.getJson('/feed');

    expect(sent.method, 'GET');
    expect(sent.url.toString(), 'https://api.test/v2/feed');
    expect(sent.headers['Accept'], 'application/json');
    expect(json['greeting'], 'Let’s go');
  });

  test('non-200 status -> ServerException', () async {
    final api = client((_) async => http.Response('Page not found', 404));
    await expectLater(
      api.getJson('/feed'),
      throwsA(isA<ServerException>().having((e) => e.statusCode, 'code', 404)),
    );
  });

  test('invalid JSON -> ParsingException', () async {
    final api = client((_) async => http.Response('<html>', 200));
    await expectLater(api.getJson('/feed'), throwsA(isA<ParsingException>()));
  });

  test('JSON array instead of object -> ParsingException', () async {
    final api = client((_) async => http.Response('[1,2]', 200));
    await expectLater(api.getJson('/feed'), throwsA(isA<ParsingException>()));
  });

  test('connection error -> NetworkException', () async {
    final api = client((_) => throw http.ClientException('Failed host lookup'));
    await expectLater(api.getJson('/feed'), throwsA(isA<NetworkException>()));
  });

  test('slow server -> NetworkException after the timeout', () async {
    final api = client(
      (_) => Completer<http.Response>().future,
      timeout: const Duration(milliseconds: 10),
    );
    await expectLater(
      api.getJson('/feed'),
      throwsA(
        isA<NetworkException>().having(
          (e) => e.message,
          'message',
          contains('too long'),
        ),
      ),
    );
  });
}
