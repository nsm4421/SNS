class CustomException implements Exception {
  CustomException._({required this.message, this.code, this.tag});

  final String message;
  final String? code;
  final String? tag;

  factory CustomException.auth({String? message, String? code}) =>
      CustomException._(
        code: code ?? 'AUTH',
        message: message ?? 'auth error',
        tag: 'AUTH',
      );

  factory CustomException.database({String? message, String? code}) =>
      CustomException._(
        message: message ?? 'database error',
        code: code,
        tag: 'DATABASE',
      );

  factory CustomException.unknown([String? message]) => CustomException._(
    message: message ?? 'unknown error',
  );

  @override
  String toString() => '[$code]: $message';
}
