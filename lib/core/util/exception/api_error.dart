import 'package:sns/core/constant/api_error_type.constant.dart';

class ApiError {
  final ApiErrorType type;
  final String message;
  final int? statusCode;

  ApiError({
    this.type = ApiErrorType.unknown,
    this.message = 'error occurs',
    this.statusCode,
  });

  @override
  String toString() => 'type: $type, status: $statusCode, msg: $message';
}
