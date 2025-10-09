part of 'auth.bloc.dart';

@freezed
sealed class AuthEvent with _$AuthEvent {
  /// 앱 시작/재시작 시 인증 상태 감시 시작
  const factory AuthEvent.started() = _Started;

  /// 이메일/비번 로그인
  const factory AuthEvent.signInRequested({
    required String email,
    required String password,
  }) = _SignInRequested;

  /// 회원가입
  const factory AuthEvent.signUpRequested({
    required String email,
    required String password,
    required String username,
    String? avatarUrl,
  }) = _SignUpRequested;

  /// 로그아웃
  const factory AuthEvent.signOutRequested() = _SignOutRequested;

  /// authStream 변화 이벤트
  const factory AuthEvent.authChanged(AppUserEntity? user) = _AuthChanged;
}
