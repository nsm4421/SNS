import '../../constant/api_error_type.constant.dart';
import 'api_error.dart';

class ApiException extends ApiError implements Exception {
  ApiException._({super.type, super.message = 'exception occurs'});

  factory ApiException.timeout([String message = 'timeout error']) {
    return ApiException._(type: ApiErrorType.timeout, message: message);
  }

  factory ApiException.notFound([String message = 'not found error']) {
    return ApiException._(type: ApiErrorType.notFound, message: message);
  }

  factory ApiException.unknown([String message = 'unknown error']) {
    return ApiException._(type: ApiErrorType.unknown, message: message);
  }
}
