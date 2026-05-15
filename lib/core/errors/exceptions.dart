class StravaApiException implements Exception {
  final int statusCode;
  final String message;

  StravaApiException(this.statusCode, this.message);

  @override
  String toString() => 'StravaApiException: $statusCode - $message';
}

class UnauthenticatedException implements Exception {
  @override
  String toString() => 'UnauthenticatedException: No valid tokens found';
}
