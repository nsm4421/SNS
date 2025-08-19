

import 'package:shared/response_wrapper/api_response/api_error_type.dart';

class ApiException implements Exception {
  const ApiException({
    this.message = 'error occurs',
    this.code,
    this.type = ApiErrorType.unknown,
  });

  final String message;
  final String? code;
  final ApiErrorType type;

  factory ApiException.network([String? message, String? code]) {
    final type = ApiErrorType.network;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.auth([String? message, String? code]) {
    final type = ApiErrorType.auth;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.notFound([String? message, String? code]) {
    final type = ApiErrorType.notFound;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.conflict([String? message, String? code]) {
    final type = ApiErrorType.conflict;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.validation([String? message, String? code]) {
    final type = ApiErrorType.validation;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.server([String? message, String? code]) {
    final type = ApiErrorType.server;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.storage([String? message, String? code]) {
    final type = ApiErrorType.storage;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }

  factory ApiException.unknown([String? message, String? code]) {
    final type = ApiErrorType.unknown;
    return ApiException(
      type: type,
      code: type.code,
      message: message ?? type.description,
    );
  }
}
