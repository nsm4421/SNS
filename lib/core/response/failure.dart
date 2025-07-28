class Failure {
  final String message;

  Failure(this.message);

  factory Failure.notFound([String? message]) =>
      Failure(message ?? 'not found error');

  factory Failure.unAuthorized([String? message]) =>
      Failure(message ?? 'authorization error');

  factory Failure.validation([String? message]) =>
      Failure(message ?? 'invalid input is given');

  factory Failure.duplicated([String? message]) =>
      Failure(message ?? 'duplicated error');

  factory Failure.network([String? message]) =>
      Failure(message ?? 'network connection error');

  factory Failure.server([String? message]) =>
      Failure(message ?? 'internal server error');

  factory Failure.unknown([String? message]) =>
      Failure(message ?? 'unknown error');
}
