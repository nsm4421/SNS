enum ApiErrorType {
  network(description: "네트워크 연결 불가 (인터넷 끊김, DNS 오류 등)"),
  auth(code: '401', description: "인증 실패"),
  forbidden(code: '403', description: "권한 없음"),
  notFound(code: '404', description: ' 리소스 없음'),
  conflict(code: '409', description: '중복 또는 충돌 '),
  validation(code: '400', description: '잘못된 요청'),
  timeout(code: '408', description: '요청 시간 초과 '),
  server(code: '500', description: ' 서버 에러'),
  storage(code: '600', description: '스토리지 업로드/다운로드 에러'),
  unknown(code: '999', description: '알수 없는 오류');

  const ApiErrorType({this.code, required this.description});

  final String? code;
  final String description;
}
