enum ErrorType {
  /// 네트워크 연결 실패
  network,

  /// 요청 시간 초과
  timeout,

  /// 인증 필요 or 토큰 만료
  unauthorized,

  /// 서버(5xx) 에러
  server,

  /// 응답 파싱 실패
  parsing,

  /// 정의되지 않은 예외
  unknown,
}
