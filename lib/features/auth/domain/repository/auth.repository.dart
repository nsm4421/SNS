import 'package:either_dart/either.dart';
import 'package:sns/core/constant/auth_state.constant.dart';
import 'package:sns/core/constant/user_profile.constant.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/features/auth/domain/entity/user.entity.dart';

abstract class AuthRepository {
  Stream<AuthStatus> get authStatusStream;

  Future<bool> getIsAuth();

  Future<Either<ApiError, UserEntity>> getCurrentUser();

  Future<Either<ApiError, UserEntity>> findByUid(String uid);

  Future<Either<ApiError, void>> signUp({
    required String email,
    required String password,
    required String username,
  });

  Future<Either<ApiError, (String accessToken, String refreshToken)>>
  signInAndReturnTokens({required String email, required String password});

  Future<Either<ApiError, void>> saveTokens({
    required String accessToken,
    required String refreshToken,
  });

  Future<Either<ApiError, void>> signOut();

  Future<Either<ApiError, String>> getRefreshToken();

  Future<Either<ApiError, void>> clearTokens();

  Future<Either<ApiError, (String accessToken, String refreshToken)>>
  getNewTokens(String oldRefreshToken);

  Future<Either<ApiError, void>> editProfile({
    String? username,
    String? description,
    Sex? sex,
  });
}
