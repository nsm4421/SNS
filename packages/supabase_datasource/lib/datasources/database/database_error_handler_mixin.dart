import 'package:response_wrapper/api_exception/api_error_type.dart';
import 'package:response_wrapper/api_exception/api_exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin class DatabaseErrorHandlerMixIn {
  ApiException toApiException(Object error, {String? message}) {
    if (error is ApiException) {
      return error;
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
      return ApiException(type: type, message: message ?? error.message);
    } else {
      return ApiException.unknown(message);
    }
  }
}
