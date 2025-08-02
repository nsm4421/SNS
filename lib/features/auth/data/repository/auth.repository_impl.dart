import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:sns/core/core.export.dart';
import 'package:sns/features/auth/data/datasource/local/local_session.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_auth.datasource_impl.dart';
import 'package:sns/features/auth/data/datasource/remote/remote_user.datasource_impl.dart';
import 'package:sns/features/auth/data/model/request/edit_profile_request.model.dart';
import 'package:sns/features/auth/data/model/request/sign_up_request.model.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl
    with AppLogger, RepositoryResponseWrapperMixIn
    implements AuthRepository {
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
  Future<bool> getIsAuth() async => await _localDataSource
      .getRefreshToken()
      .then((token) => token != null && token.isNotEmpty);

  @override
  Future<Either<ApiError, UserEntity>> getCurrentUser() async =>
      await guardApi<UserEntity>(() async {
        return _remoteAuthDataSource.getAuthUser().then(
          UserEntity.fromAuthUserModel,
        );
      }, logger: logger);

  @override
  Future<Either<ApiError, UserEntity>> findByUid(String uid) async =>
      await guardApi<UserEntity>(() async {
        return await _remoteUserDataSource
            .findByUId(uid)
            .then(UserEntity.fromUserModel);
      }, logger: logger);

  @override
  Future<Either<ApiError, void>> signUp({
    required String email,
    required String password,
    required String username,
    Sex? sex,
    String? description,
  }) async => await guardApi<void>(() async {
    await _remoteAuthDataSource.signUp(
      SignUpRequestModel(
        email: email,
        username: username,
        password: password,
        sex: sex,
        description: description,
      ),
    );
  }, logger: logger);

  @override
  Future<Either<ApiError, (String accessToken, String refreshToken)>>
  signInAndReturnTokens({
    required String email,
    required String password,
  }) async => await guardApi<(String, String)>(() async {
    // 로그인 처리하고, 발급받은 토큰 return
    return await _remoteAuthDataSource.signIn(email: email, password: password);
  }, logger: logger);

  @override
  Future<Either<ApiError, void>> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async => guardApi(() async {
    await _localDataSource.setAccessToken(accessToken);
    await _localDataSource.setRefreshToken(refreshToken);
  }, logger: logger);

  @override
  Future<Either<ApiError, void>> signOut() async =>
      await guardApi<void>(() async {
        await _remoteAuthDataSource.signOut();
      });

  @override
  Future<Either<ApiError, String>> getRefreshToken() async =>
      await guardApi<String>(() async {
        final token = await _localDataSource.getRefreshToken();
        if (token == null) {
          throw ApiException.notFound('refresh token not founded');
        }
        return token;
      }, logger: logger);

  @override
  Future<Either<ApiError, void>> clearTokens() async =>
      await guardApi<void>(() async {
        await _localDataSource.clearAccessToken();
        await _localDataSource.clearRefreshToken();
      });

  @override
  Future<Either<ApiError, (String accessToken, String refreshToken)>>
  getNewTokens(String oldRefreshToken) async =>
      await guardApi<(String, String)>(() async {
        final session = await _remoteAuthDataSource.restoreSession(
          oldRefreshToken,
        );
        if (session == null) {
          throw ApiException.notFound('session is not founded');
        } else if (session.refreshToken == null) {
          throw ApiException.notFound('refresh token is not founded');
        }
        return (session.accessToken, session.refreshToken!);
      }, logger: logger);

  @override
  Future<Either<ApiError, void>> editProfile({
    String? username,
    String? description,
    Sex? sex,
  }) async => await guardApi<void>(() async {
    // auth.users 테이블의 userMetaData필드 업데이트
    // trigger에 의해 public.users테이블도 업데이트
    await _remoteAuthDataSource.editProfile(
      EditProfileRequestModel(
        username: username,
        description: description,
        sex: sex,
      ),
    );
  }, logger: logger);
}
