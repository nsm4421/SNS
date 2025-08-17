import 'package:data/core/exception/api_error_type.dart';
import 'package:data/core/exception/api_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin class ApiResponseWrapperMixIn {
  ApiException toException(Object error) {
    if (error is ApiException) {
      return error;
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
      return type.toException(message: error.message);
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
      return type.toException(message: error.message);
    } else if (error is StorageException) {
      // Storage 오류
      return ApiErrorType.storage.toException(message: error.message);
    } else {
      // 그 외 오류
      return ApiErrorType.unknown.toException();
    }
  }
}
