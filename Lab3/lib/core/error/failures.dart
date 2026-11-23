/// Errors the Domain and Presentation layers understand.
/// The repository turns low-level Data exceptions into one of these,
/// so the UI never sees HTTP or JSON details.
sealed class Failure implements Exception {
  final String message;

  const Failure(this.message);

  @override
  String toString() => message;
}

/// No internet, server unreachable, request blocked, or timeout.
class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Can\'t reach the server. Check your connection.',
  ]);
}

/// The server answered with an error status (4xx / 5xx).
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure(this.statusCode)
    : super('The server returned an error ($statusCode).');
}

/// The response wasn't the JSON we expected.
class ParsingFailure extends Failure {
  const ParsingFailure([
    super.message = 'The server sent data in an unexpected format.',
  ]);
}
