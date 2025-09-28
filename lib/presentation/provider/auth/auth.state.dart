part of 'auth.bloc.dart';

@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;

  /// authStream 바인딩/요청 처리 중
  const factory AuthState.loading() = _Loading;

  /// 로그인 완료
  const factory AuthState.authenticated(AppUserEntity user) = _Authenticated;

  /// 로그아웃 상태
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// 액션 실패 (signIn/signUp/signOut 등)
  const factory AuthState.failure(Failure error) = _Failure;
}
