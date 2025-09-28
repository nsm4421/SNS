import 'package:shared/src/error_code.dart';

class CustomException implements Exception {
  CustomException._({
    required this.message,
    this.code = ErrorCode.unKnown,
    this.tag,
  });

  final String message;
  final ErrorCode code;
  final String? tag;

  factory CustomException.auth({
    String? message,
    ErrorCode code = ErrorCode.unKnown,
  }) => CustomException._(
    code: code,
    message: message ?? 'auth error',
    tag: 'AUTH',
  );

  factory CustomException.database({
    String? message,
    ErrorCode code = ErrorCode.unKnown,
  }) => CustomException._(
    message: message ?? 'database error',
    code: code,
    tag: 'DATABASE',
  );

  factory CustomException.localStorage({
    String? message,
    ErrorCode code = ErrorCode.unKnown,
  }) => CustomException._(
    message: message ?? 'local storage error',
    code: code,
    tag: 'LOCAL_STORAGE',
  );

  factory CustomException.unknown([String? message]) =>
      CustomException._(message: message ?? 'unknown error', tag: 'UNKNOWN');

  @override
  String toString() => '[${code.name}]: $message';
}
