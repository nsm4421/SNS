import 'package:response_wrapper/api_exception/api_error_type.dart';
import 'package:response_wrapper/api_exception/api_exception.dart';

class ApiError {
  ApiError({
    this.message = 'error occurs',
    this.code,
    this.type = ApiErrorType.unknown,
  });

  final String message;
  final String? code;
  final ApiErrorType type;

  factory ApiError.fromException(ApiException e) {
    return ApiError(message: e.message, code: e.code, type: e.type);
  }

  factory ApiError.fromError(Object e) {
    if (e is ApiException) {
      return ApiError.fromError(e);
    } else {
      return ApiError(message: 'unhandled exception');
    }
  }
}
