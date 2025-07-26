import 'package:injectable/injectable.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/core/util/logger/sington_logger.util.dart';
import 'package:sns/features/auth/data/datasource/local/local_session.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_user.datasource_impl.dart';
import 'package:sns/features/auth/data/model/request/edit_profile_request.model.dart';
import 'package:sns/features/auth/data/model/request/sign_up_request.model.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with AppLogger implements AuthRepository {
  final RemoteAuthDataSource _remoteAuthDataSource;
  final RemoteUserDataSource _remoteUserDataSource;
  final LocalSessionDataSource _localDataSource;

  AuthRepositoryImpl({
    required RemoteAuthDataSource remoteAuthDataSource,
    required RemoteUserDataSource remoteUserDataSource,
    required LocalSessionDataSource localDataSource,
  }) : _remoteAuthDataSource = remoteAuthDataSource,
       _remoteUserDataSource = remoteUserDataSource,
       _localDataSource = localDataSource;

  @override
  Future<bool> getIsAuth() async {
    return await _localDataSource.getRefreshToken().then(
      (token) => token != null && token.isNotEmpty,
    );
  }

  @override
  Future<UserEntity?> findByUid(String uid) async {
    final res = await _remoteUserDataSource.findByUId(uid);
    return res == null ? null : UserEntity.fromUserModel(res);
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    return _remoteAuthDataSource.getAuthUser().then(
      UserEntity.fromAuthUserModel,
    );
  }

  @override
  Stream<AuthStatus> get authStatusStream async* {
    // AuthState(supabase) -> AuthStatus로 전환하기
    yield AuthStatus.checking; // 최초상태는 checking(인증상태 체크중)
    await for (final event in _remoteAuthDataSource.authStateStream) {
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
    Sex? sex,
    String? description,
  }) async {
    await _remoteAuthDataSource.signUp(
      SignUpRequestModel(
        email: email,
        username: username,
        password: password,
        sex: sex,
        description: description,
      ),
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    // 로그인 처리하고 토큰 발급받기
    final (accessToken, refreshToken) = await _remoteAuthDataSource.signIn(
      email: email,
      password: password,
    );
    // 발급받은 토큰 저장
    await _localDataSource.setAccessToken(accessToken);
    await _localDataSource.setRefreshToken(refreshToken);
  }

  @override
  Future<void> signOut() async {
    await _remoteAuthDataSource.signOut();
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
    final session = await _remoteAuthDataSource.restoreSession(refreshToken);
    if (session == null) {
      throw Exception('restore session fails');
    } else if (session.refreshToken == null) {
      throw Exception('refresh token is invalid');
    }
    // 발급받은 토큰을 로컬 스토리지에 저장
    await _localDataSource.setAccessToken(session.accessToken);
    await _localDataSource.setRefreshToken(session.refreshToken!);
  }

  @override
  Future<void> editProfile({
    String? username,
    String? description,
    Sex? sex,
  }) async {
    // auth.users 테이블의 userMetaData필드 업데이트
    // trigger에 의해 public.users테이블도 업데이트
    await _remoteAuthDataSource.editProfile(
      EditProfileRequestModel(
        username: username,
        description: description,
        sex: sex,
      ),
    );
  }
}
