import 'package:shared/exception/api/api_error_type.dart';
import 'package:shared/exception/api/api_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiError {
  ApiError({
    this.message = 'error occurs',
    this.code,
    this.type = ApiErrorType.unknown,
  });

  final String message;
  final String? code;
  final ApiErrorType type;

  factory ApiError.from(Object error) {
    if (error is ApiError) {
      return error;
    } else if (error is ApiException) {
      return ApiError(
        message: error.message,
        code: error.code,
        type: error.type,
      );
    } else if (error is AuthException) {
      // 인증 오류
      final status = int.tryParse(error.statusCode ?? '') ?? 0;
      final type = switch (status) {
        401 => ApiErrorType.auth,
        403 => ApiErrorType.forbidden,
        408 => ApiErrorType.timeout,
        400 => ApiErrorType.validation,
        >= 500 => ApiErrorType.server,
        _ => ApiErrorType.unknown,
      };
      return ApiError(
        message: error.message,
        code: error.code,
        type: type,
      );
    } else if (error is PostgrestException) {
      // DB오류
      final code = int.tryParse(error.code ?? '');
      final type = switch (code) {
        400 => ApiErrorType.validation,
        401 => ApiErrorType.auth,
        403 => ApiErrorType.forbidden,
        404 => ApiErrorType.forbidden,
        408 => ApiErrorType.timeout,
        409 => ApiErrorType.conflict,
        (_) => ApiErrorType.server,
      };
      return ApiError(
        message: error.message,
        code: error.code,
        type: type,
      );
    } else if (error is StorageException) {
      // Storage 오류
      return ApiError(
        message: error.message,
        code: error.message,
        type: ApiErrorType.storage,
      );
    } else {
      // 그 외 오류
      return ApiError(
        message: ApiErrorType.unknown.description,
        code: ApiErrorType.unknown.code,
        type: ApiErrorType.unknown,
      );
    }
  }
}
