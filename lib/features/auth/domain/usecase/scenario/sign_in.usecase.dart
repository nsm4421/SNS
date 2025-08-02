part of '../auth.usecases.dart';

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
