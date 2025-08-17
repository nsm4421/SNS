import 'api_error_type.dart';

class ApiException implements Exception {
  const ApiException({
    this.message = 'error occurs',
    this.code,
    this.type = ApiErrorType.unknown,
  });

  final String message;
  final String? code;
  final ApiErrorType type;

  factory ApiException.network([String? message]) =>
      ApiErrorType.network.toException(message: message);

  factory ApiException.auth([String? message]) =>
      ApiErrorType.auth.toException(message: message);

  factory ApiException.notFound([String? message]) =>
      ApiErrorType.notFound.toException(message: message);

  factory ApiException.conflict([String? message]) =>
      ApiErrorType.conflict.toException(message: message);

  factory ApiException.validation([String? message]) =>
      ApiErrorType.validation.toException(message: message);

  factory ApiException.server([String? message]) =>
      ApiErrorType.server.toException(message: message);

  factory ApiException.storage([String? message]) =>
      ApiErrorType.storage.toException(message: message);

  factory ApiException.unknown([String? message]) =>
      ApiErrorType.unknown.toException(message: message);
}
