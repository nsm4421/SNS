enum Status { initial, loading, error, success }

enum DisplayStatus { initial, fetching, loaded, error }

enum AuthStatus {
  checking, // 인증상태 확인 중
  authenticated,
  unauthenticated,
}
