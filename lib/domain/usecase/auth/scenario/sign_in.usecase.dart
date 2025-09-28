part of '../auth.usecases.dart';

final class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  Future<Either<Failure, AppUserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _repository
        .signIn(email: email, password: password)
        .then(
          (res) => res.mapLeft((l) {
            if (l.code == ErrorCode.invalidCredential) {
              return l.copyWith(AuthErrorMessage.invalidCredentials.message);
            }
            return l.copyWith('sign in fail');
          }),
        );
  }
}
