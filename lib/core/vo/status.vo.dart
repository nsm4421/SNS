enum DisplayStatus {
  initial, // 기본/안정 상태 (첫 진입 직전, 혹은 로딩 종료 후)
  loading, // 초기 로딩 (또는 강제 전체 로딩)
  refreshing, // Pull-to-refresh 동작 중
  paginated, // 다음 페이지 로딩 중 (하단 스피너)
}

enum ComposeStatus { idle, submitting, success, failure }