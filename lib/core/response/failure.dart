import '../constant/error_type.constant.dart';
import 'api_exception.dart';

class Failure {
  final ErrorType type;
  final String message;

  const Failure._({
    this.type = ErrorType.unknown,
    this.message = 'error occurs',
  });

  /// 네트워크 연결 실패
  factory Failure.network([String message = 'network connection error']) {
    return Failure._(type: ErrorType.network, message: message);
  }

  /// 요청 시간 초과
  factory Failure.timeout([String message = 'time out error']) {
    return Failure._(type: ErrorType.timeout, message: message);
  }

  /// 인증 필요 / 토큰 만료
  factory Failure.unauthorized([String message = 'auth error']) {
    return Failure._(type: ErrorType.unauthorized, message: message);
  }

  /// 서버(5xx) 오류
  factory Failure.server([String message = 'server error']) {
    return Failure._(type: ErrorType.server, message: message);
  }

  /// 응답 파싱 실패
  factory Failure.parsing([String message = 'parsing error']) {
    return Failure._(type: ErrorType.parsing, message: message);
  }

  /// 그 외 알 수 없는 오류
  factory Failure.unknown([String message = 'undefied error']) {
    return Failure._(type: ErrorType.unknown, message: message);
  }

  factory Failure._fromApiException(ApiException e, {String? message}) {
    return switch (e.type) {
      ErrorType.network => Failure.network(message ?? e.message),
      ErrorType.timeout => Failure.timeout(message ?? e.message),
      ErrorType.unauthorized => Failure.unauthorized(message ?? e.message),
      ErrorType.server => Failure.server(message ?? e.message),
      ErrorType.parsing => Failure.parsing(message ?? e.message),
      ErrorType.unknown => Failure.unknown(message ?? e.message),
    };
  }

  factory Failure.fromError(Object e, {String? message}) {
    return e is ApiException
        ? Failure._fromApiException(e, message: message)
        : Failure.unknown(message ?? 'undefined error');
  }

  @override
  String toString() => 'Failure(type: \$type, message: \$message)';
}
