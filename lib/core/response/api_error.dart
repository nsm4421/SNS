enum ApiErrorType {
  network, // 네트워크 연결 불가 (인터넷 끊김, DNS 오류 등)
  unauthorized, // 인증 실패 (401)
  forbidden, // 권한 없음 (403)
  notFound, // 리소스 없음 (404)
  conflict, // 중복 또는 충돌 (409)
  validation, // 잘못된 요청 (400)
  timeout, // 요청 시간 초과 (408)
  server, // 서버 에러 (5xx)
  storage, // 스토리지 업로드/다운로드 에러
  unknown, // 그 외 알 수 없는 오류
}

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

class ApiException extends ApiError implements Exception {
  ApiException._({super.type, super.message = 'exception occurs'});

  factory ApiException.timeout([String message = 'timeout error']) {
    return ApiException._(type: ApiErrorType.timeout, message: message);
  }

  factory ApiException.notFound([String message = 'not found error']) {
    return ApiException._(type: ApiErrorType.notFound, message: message);
  }

  factory ApiException.unknown([String message = 'unknown error']) {
    return ApiException._(type: ApiErrorType.unknown, message: message);
  }
}
