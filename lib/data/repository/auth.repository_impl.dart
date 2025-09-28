import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/vo/failure.vo.dart';
import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/repository/auth.repository.dart';
import 'package:local_storage/local_storage.dart';
import 'package:supabase_datasource/supabase_datasource.dart';
import 'package:karma/data/mapper/user_entity.mapper.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;
  final SecureLocalStorageDataSource _secureLocalStorageDataSource;

  AuthRepositoryImpl({
    required AuthDataSource authDataSource,
    required SecureLocalStorageDataSource secureLocalStorageDataSource,
  }) : _authDataSource = authDataSource,
       _secureLocalStorageDataSource = secureLocalStorageDataSource;

  @override
  Stream<AppUserEntity?> get authStream =>
      _authDataSource.authStatusStream.asyncMap(
        (e) => e.when(
          signedIn: (accessToken, refreshToken, user) async {
            if (accessToken != null) {
              await _saveAccessToken(accessToken);
            }
            if (refreshToken != null) {
              await _saveRefreshToken(refreshToken);
            }
            return user.toEntity();
          },
          signedOut: () => null,
          tokenRefreshed: (accessToken, refreshToken, user) async {
            if (accessToken != null) {
              await _saveAccessToken(accessToken);
            }
            if (refreshToken != null) {
              await _saveRefreshToken(refreshToken);
            }
            return user?.toEntity();
          },
          userUpdated: (user) => user.toEntity(),
          unknown: (message) => null,
        ),
      );

  @override
  Future<Either<Failure, AppUserEntity>> signUp({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    try {
      final res = await _authDataSource.signUp(
        SignUpRequestDto(
          email: email,
          password: password,
          username: username,
          avatarUrl: avatarUrl,
        ),
      );
      if (res.accessToken != null) {
        _saveAccessToken(res.accessToken!);
      }
      if (res.refreshToken != null) {
        _saveRefreshToken(res.refreshToken!);
      }
      return Right(res.user.toEntity());
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> getCurrentUser() async {
    try {
      return await _authDataSource
          .getCurrentUser()
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> refreshSession() async {
    try {
      // TODO : 로컬스토리지에 있는 토큰이 있으면 해당 토큰으로 다시 세션 가져오기
      final res = await _authDataSource.refreshSession();
      if (res.accessToken != null) {
        _saveAccessToken(res.accessToken!);
      }
      if (res.refreshToken != null) {
        _saveRefreshToken(res.refreshToken!);
      }
      return Right(res.user.toEntity());
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, AppUserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final res = await _authDataSource.signIn(
        SignInRequestDto(email: email, password: password),
      );
      if (res.accessToken != null) {
        _saveAccessToken(res.accessToken!);
      }
      if (res.refreshToken != null) {
        _saveRefreshToken(res.refreshToken!);
      }
      return Right(res.user.toEntity());
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _authDataSource.signOut();
      await _clearAccessToken();
      await _clearRefreshToken();
      return const Right(null);
    } catch (e) {
      return Left(Failure.fromObj(e));
    }
  }

  Future<void> _saveAccessToken(String token) async {
    await _secureLocalStorageDataSource.write(
      key: 'ACCESS_TOKEN',
      value: token,
    );
  }

  Future<void> _clearAccessToken() async {
    await _secureLocalStorageDataSource.delete('ACCESS_TOKEN');
  }

  Future<void> _saveRefreshToken(String token) async {
    await _secureLocalStorageDataSource.write(
      key: 'REFRESH_TOKEN',
      value: token,
    );
  }

  Future<void> _clearRefreshToken() async {
    await _secureLocalStorageDataSource.delete('REFRESH_TOKEN');
  }
}
