import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/features/auth/data/datasource/local/local_session.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource _remoteDataSource;
  final LocalSessionDataSource _localDataSource;

  AuthRepositoryImpl({
    required RemoteAuthDataSource remoteDataSource,
    required LocalSessionDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Stream<AuthStatus> get authStatusStream async* {
    // AuthState(supabase) -> AuthStatus로 전환하기
    yield AuthStatus.checking;  // 최초상태는 checking(인증상태 체크중)
    await for (final event in _remoteDataSource.authStateStream) {
      if (event.session?.user != null) {
        yield AuthStatus.authenticated;
      } else {
        yield AuthStatus.unauthenticated;
      }
    }
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String username,
  }) async {
    await _remoteDataSource.signUp(
      email: email,
      password: password,
      username: username,
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    // 로그인 처리하고 토큰 발급받기
    final (accessToken, refreshToken) = await _remoteDataSource.signIn(
      email: email,
      password: password,
    );
    // 발급받은 토큰 저장
    await _localDataSource.setAccessToken(accessToken);
    await _localDataSource.setRefreshToken(refreshToken);
  }

  @override
  Future<void> signOut() async {
    await _remoteDataSource.signOut();
    await _localDataSource.clearAccessToken();
    await _localDataSource.clearRefreshToken();
  }

  @override
  Future<void> restoreSession() async {
    // 로컬 스토리지에서 리프레쉬 토큰 꺼내기
    final refreshToken = await _localDataSource.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw Exception('refresh token is missing');
    }
    // 원격서버로부터 토큰 재발급 받기
    final session = await _remoteDataSource.restoreSession(refreshToken);
    if (session == null) {
      throw Exception('restore session fails');
    } else if (session.refreshToken == null) {
      throw Exception('refresh token is invalid');
    }
    // 발급받은 토큰을 로컬 스토리지에 저장
    await _localDataSource.setAccessToken(session.accessToken);
    await _localDataSource.setRefreshToken(session.refreshToken!);
  }
}
