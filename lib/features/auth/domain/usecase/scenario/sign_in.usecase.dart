import 'package:either_dart/either.dart';
import 'package:sns/core/response/api_error.dart';
import 'package:sns/core/response/api_error_to_failure_mapper_mixin.dart';
import 'package:sns/core/response/failure.dart';
import 'package:sns/features/auth/domain/repository/auth.repository.dart';

class SignInUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) async {
    final signInRes = await _repository
        .signInAndReturnTokens(email: email, password: password)
        .thenLeft((l) {
          return Left(() {
            switch (l.type) {
              case ApiErrorType.unauthorized:
              case ApiErrorType.validation:
                return Failure.unAuthorized('invalid credential');
              case ApiErrorType.notFound:
                return Failure.unAuthorized('user not found');
              default:
                return handleFailure(l);
            }
          }());
        });
    if (signInRes.isLeft) return signInRes;

    final saveTokenRes = await _repository
        .saveTokens(
          accessToken: signInRes.right.$1,
          refreshToken: signInRes.right.$2,
        )
        .thenLeft((l) => Left(handleFailure(l)));
    if (saveTokenRes.isLeft) return saveTokenRes;

    return const Right(null);
  }
}
