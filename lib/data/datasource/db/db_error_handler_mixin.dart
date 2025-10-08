import 'package:karma/core/core.export.dart';
import 'package:supabase/supabase.dart';

mixin class DbErrorHandlerMixin {
  Never throwCustomExceptionFromPostgresException(PostgrestException e) {
    final supabaseErrorCode = (e.code ?? '').toUpperCase();
    final supabaseErrorMessage = e.message.toLowerCase() ?? '';

    if (supabaseErrorCode == '23505' ||
        supabaseErrorMessage.contains('duplicate key')) {
      throw CustomException.database(
        message: 'Unique violation',
        code: ErrorCode.duplicated,
      );
    } else if (supabaseErrorCode == '42501' ||
        supabaseErrorMessage.contains('permission denied')) {
      throw CustomException.database(
        message: 'permission denied',
        code: ErrorCode.permissionDenied,
      );
    } else if (supabaseErrorCode == 'PGRST116' ||
        supabaseErrorMessage.contains('no rows') ||
        supabaseErrorMessage.contains('multiple rows') ||
        supabaseErrorMessage.contains('json object requested')) {
      throw CustomException.database(
        message: 'not found',
        code: ErrorCode.notFound,
      );
    } else if (supabaseErrorCode == '401' ||
        supabaseErrorMessage.contains('jwt') ||
        supabaseErrorMessage.contains('auth')) {
      throw CustomException.auth(message: 'authorization fails');
    } else {
      throw CustomException.database(
        message: 'unknown error occurs on database',
      );
    }
  }
}
