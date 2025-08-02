part of '../auth.usecases.dart';

class SignUpUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
    required String username,
  }) async {
    return await _repository
        .signUp(email: email, password: password, username: username)
        .thenLeft((l) {
          return Left(() {
            switch (l.type) {
              case ApiErrorType.validation:
                if (l.message.contains('password')) {
                  return Failure.validation('password is too week');
                }
                if (l.message.contains('email')) {
                  return Failure.validation('email is invalid');
                }
                return handleFailure(l);
              case ApiErrorType.conflict:
                return Failure.duplicated('email is duplicated');
              default:
                return handleFailure(l);
            }
          }());
        });
  }
}
