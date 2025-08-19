import 'package:logger/logger.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:shared/response_wrapper/failure/failure.dart';

extension LoggerExtension on Logger {
  logApiError(ApiError apiError) {
    e([apiError.type, apiError.code, apiError.message]);
  }

  logFailure(Failure failure) {
    e([failure.message]);
  }
}
