import 'package:dio/dio.dart';
import 'package:karma/core/core.export.dart';
import 'package:supabase/supabase.dart';

mixin class StorageHandlerMixin {
  Never throwCustomExceptionFromException(Object e) {
    if (e is DioException) {
      throw CustomException.storage(
        message: e.response?.data is String
            ? (e.response?.data as String)
            : (e.message ?? 'Network e'),
        code:
            (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionError)
            ? ErrorCode.network
            : ErrorCode.unKnown,
      );
    } else if (e is StorageException) {
      throw CustomException.storage(
        message: e.message,
        code: switch (e.statusCode) {
          '401' => ErrorCode.unAuthorized,
          '403' => ErrorCode.permissionDenied,
          '404' => ErrorCode.notFound,
          '409' => ErrorCode.conflict,
          '413' => ErrorCode.tooLargeRequest,
          '415' => ErrorCode.unSupportedMedia,
          '429' => ErrorCode.ratedLimited,
          '500' => ErrorCode.internalServer,
          '502' => ErrorCode.internalServer,
          '503' => ErrorCode.internalServer,
          '504' => ErrorCode.internalServer,
          (_) => ErrorCode.unKnown,
        },
      );
    } else {
      throw CustomException.storage();
    }
  }
}
