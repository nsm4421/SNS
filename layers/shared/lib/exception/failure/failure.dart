import 'package:shared/exception/api/api_error.dart';
import 'package:shared/exception/api/api_error_type.dart';

class Failure {
  final String message;

  Failure(this.message);

  factory Failure.network([String? message]) =>
      Failure(message ?? '네트워크 연결 불가 (인터넷 끊김, DNS 오류 등)');

  factory Failure.auth([String? message]) => Failure(message ?? '인증 실패');

  factory Failure.forbidden([String? message]) => Failure(message ?? '권한 없음');

  factory Failure.notFound([String? message]) => Failure(message ?? '리소스 없음');

  factory Failure.conflict([String? message]) => Failure(message ?? '중복 또는 충돌');

  factory Failure.validation([String? message]) => Failure(message ?? '잘못된 요청');

  factory Failure.timeout([String? message]) => Failure(message ?? '요청 시간 초과');

  factory Failure.server([String? message]) => Failure(message ?? '서버 에러');

  factory Failure.unknown([String? message]) => Failure(message ?? '알수 없는 오류');

  @override
  String toString() => 'Failure:$message';

  factory Failure.from(ApiError error) {
    switch (error.type) {
      case ApiErrorType.auth:
        return Failure.auth(error.message);
      case ApiErrorType.forbidden:
        return Failure.forbidden(error.message);
      case ApiErrorType.notFound:
        return Failure.notFound(error.message);
      case ApiErrorType.conflict:
        return Failure.conflict(error.message);
      case ApiErrorType.validation:
        return Failure.validation(error.message);
      case ApiErrorType.timeout:
        return Failure.timeout(error.message);
      case ApiErrorType.server:
      case ApiErrorType.storage:
        return Failure.server(error.message);
      default:
        return Failure.unknown(error.message);
    }
  }
}
