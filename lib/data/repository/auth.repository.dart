import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:local_storage_datasource/datasource/local_storage.datasource.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/core/constant/status.constant.dart';
import 'package:sns/data/model/mapper/auth_user_model.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/auth.repository.dart';
import 'package:supabase_datasource/datasources/auth/auth.datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required SupabaseAuthDataSource supabaseAuthDataSource,
    required LocalStorageDataSource localStorageDataSource,
  }) : _supabaseAuthDataSource = supabaseAuthDataSource,
       _localStorageDataSource = localStorageDataSource;

  final SupabaseAuthDataSource _supabaseAuthDataSource;
  final LocalStorageDataSource _localStorageDataSource;

  // local storage에 토큰을 저장할 키 값
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  @override
  Stream<AuthStatus> get authStatusStream async* {
    yield AuthStatus.checking; // 최초상태는 checking(인증상태 체크중)
    await for (final event in _supabaseAuthDataSource.authStateStream) {
      if (event.session?.user != null) {
        yield AuthStatus.authenticated;
      } else {
        yield AuthStatus.unauthenticated;
      }
    }
  }

  @override
  Future<Either<ApiError, AuthUserEntity>> getCurrentUser() async {
    try {
      return await _supabaseAuthDataSource
          .getCurrentAuthUser()
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, (String, String?)>> getNewTokensByRefreshToken(
    String oldRefreshToken,
  ) async {
    try {
      return await _supabaseAuthDataSource
          .getNewTokensByRefreshToken(oldRefreshToken)
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, (String, String?)>> signInAndReturnTokens({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabaseAuthDataSource
          .signInAndReturnTokens(email: email, password: password)
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> signOut() async {
    try {
      return await _supabaseAuthDataSource.signOut().then(
        (_) => const Right(null),
      );
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, (String, String?)>> signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  }) async {
    try {
      return await _supabaseAuthDataSource
          .signUpAndReturnTokens(
            email: email,
            password: password,
            username: username,
            profileImage: profileImage,
          )
          .then(Right.new);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> saveTokensInLocalStorage({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      await _localStorageDataSource.write(
        key: _accessTokenKey,
        value: accessToken,
      );
      if (refreshToken != null || refreshToken!.isNotEmpty) {
        await _localStorageDataSource.write(
          key: _refreshTokenKey,
          value: refreshToken,
        );
      }
      return const Right(null);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteTokensInLocalStorage() async {
    try {
      await _localStorageDataSource.delete(_accessTokenKey);
      await _localStorageDataSource.delete(_refreshTokenKey);
      return const Right(null);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, String>> getRefreshTokenFromLocalStorage() async {
    try {
      final refreshToken = await _localStorageDataSource.read(_refreshTokenKey);
      return Right(refreshToken);
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }
}
