import '../constant/error_type.constant.dart';

class ApiException implements Exception {
  final ErrorType type;

  final String message;

  const ApiException({this.type = ErrorType.unknown, required this.message});

  @override
  String toString() => '[ApiError](type: $type, message: $message)';
}
