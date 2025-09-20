class CustomException implements Exception {
  CustomException._({required this.message, this.code});

  final String message;
  final String? code;

  factory CustomException.auth({String? message, String? code}) =>
      CustomException._(
        code: code ?? 'AUTH',
        message: message ?? 'auth error',
      );

  factory CustomException.unknown([String? message]) =>
      CustomException._(
        message: message ?? 'unknown error',
      );
}
