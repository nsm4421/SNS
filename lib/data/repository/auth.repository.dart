import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:shared/constant/auth_status.constant.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:sns/core/logger/app_logger.dart';
import 'package:sns/data/datasource/auth/auth.datasource_impl.dart';
import 'package:sns/data/model/mapper/auth_user_model.extension.dart';
import 'package:sns/domain/entity/user/user.entity.dart';
import 'package:sns/domain/repository/auth.repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl with AppLogger implements AuthRepository {
  AuthRepositoryImpl(this._authDataSource);

  final AuthDataSource _authDataSource;

  @override
  Stream<AuthStatus> get authStatusStream => _authDataSource.authStatusStream;

  @override
  Future<Either<ApiError, AuthUserEntity>> getCurrentUser() async {
    try {
      return await _authDataSource
          .getCurrentAuthUser()
          .then((res) => res.toEntity())
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, (String, String?)>> getNewTokensByRefreshToken(
    String oldRefreshToken,
  ) async {
    try {
      return await _authDataSource
          .getNewTokensByRefreshToken(oldRefreshToken)
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, (String, String?)>> signInAndReturnTokens({
    required String email,
    required String password,
  }) async {
    try {
      return await _authDataSource
          .signInAndReturnTokens(email: email, password: password)
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> signOut() async {
    try {
      return await _authDataSource.signOut().then((_) => const Right(null));
    } catch (error) {
      logger.e(error);
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
      return await _authDataSource
          .signUpAndReturnTokens(
            email: email,
            password: password,
            username: username,
            profileImage: profileImage,
          )
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> saveTokensInLocalStorage({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      return await _authDataSource
          .saveTokensInLocalStorage(
            accessToken: accessToken,
            refreshToken: refreshToken,
          )
          .then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, void>> deleteTokensInLocalStorage() async {
    try {
      return await _authDataSource.deleteTokensInLocalStorage().then(Right.new);
    } catch (error) {
      logger.e(error);
      return Left(ApiError.fromError(error));
    }
  }

  @override
  Future<Either<ApiError, String>> getRefreshTokenFromLocalStorage() async {
    try {
      return await _authDataSource.getRefreshTokenFromLocalStorage().then(
        Right.new,
      );
    } catch (error) {
      return Left(ApiError.fromError(error));
    }
  }
}
