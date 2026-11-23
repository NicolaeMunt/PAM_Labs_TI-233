// Low-level errors thrown inside the Data layer.
// The repository catches them and turns them into a `Failure`.

/// Could not reach the server (no internet, DNS, CORS, timeout...).
class NetworkException implements Exception {
  final String message;

  const NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

/// The server answered with a status other than 200.
class ServerException implements Exception {
  final int statusCode;

  const ServerException(this.statusCode);

  @override
  String toString() => 'ServerException: HTTP $statusCode';
}

/// The body was not valid JSON, or not the shape we expected.
class ParsingException implements Exception {
  final Object? cause;

  const ParsingException([this.cause]);

  @override
  String toString() => 'ParsingException: $cause';
}
