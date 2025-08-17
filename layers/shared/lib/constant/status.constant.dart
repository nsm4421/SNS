enum Status { initial, loading, error, success }

enum DisplayStatus { initial, fetching, loaded, error }

enum AuthStatus {
  checking, // 인증상태 확인 중
  authenticated,
  unauthenticated,
}

enum CastVoteStatus {
  idle, // 아직 topic detail을 가져오지 않은 상태
  unVoted,
  voted,
}
