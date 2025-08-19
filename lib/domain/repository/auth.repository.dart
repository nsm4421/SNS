import 'package:either_dart/either.dart';
import 'package:response_wrapper/api_exception/api_error.dart';
import 'package:sns/core/constant/status.costant.dart';
import 'package:sns/domain/entity/user/user.entity.dart';

abstract interface class AuthRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<Either<ApiError, AuthUserEntity>> getCurrentUser();

  Future<Either<ApiError, (String accessToken, String? refreshToken)>>
  signUpAndReturnTokens({
    required String email,
    required String password,
    required String username,
    String? profileImage,
  });

  Future<Either<ApiError, (String, String?)>> signInAndReturnTokens({
    required String email,
    required String password,
  });

  Future<Either<ApiError, void>> signOut();

  Future<Either<ApiError, (String, String?)>> getNewTokensByRefreshToken(
    String oldRefreshToken,
  );

  Future<Either<ApiError, String>> getRefreshTokenFromLocalStorage();

  Future<Either<ApiError, void>> saveTokensInLocalStorage({
    required String accessToken,
    String? refreshToken,
  });

  Future<Either<ApiError, void>> deleteTokensInLocalStorage();
}
