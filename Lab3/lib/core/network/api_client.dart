import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../error/exceptions.dart';
import 'api_config.dart';

/// Thin wrapper around `http.Client`: builds the URL, sends the request,
/// checks the status code and decodes the JSON body.
class ApiClient {
  final http.Client _client;
  final String baseUrl;
  final Duration timeout;

  ApiClient(
    this._client, {
    this.baseUrl = ApiConfig.baseUrl,
    this.timeout = ApiConfig.timeout,
  });

  /// GET [path] and return the decoded JSON object.
  ///
  /// Throws [NetworkException], [ServerException] or [ParsingException].
  Future<Map<String, dynamic>> getJson(String path) async {
    final uri = Uri.parse('$baseUrl$path');

    final http.Response response;
    try {
      response = await _client
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on TimeoutException {
      throw const NetworkException('The server took too long to respond.');
    } on http.ClientException catch (e) {
      throw NetworkException(e.message);
    }

    if (response.statusCode != 200) {
      throw ServerException(response.statusCode);
    }

    try {
      // Decode as UTF-8 explicitly so characters like "’" come out right.
      final body = jsonDecode(utf8.decode(response.bodyBytes));
      if (body is! Map<String, dynamic>) {
        throw const FormatException('Expected a JSON object');
      }
      return body;
    } on FormatException catch (e) {
      throw ParsingException(e);
    }
  }

  void close() => _client.close();
}
