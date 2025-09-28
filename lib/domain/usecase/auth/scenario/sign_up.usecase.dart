part of '../auth.usecases.dart';

final class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  Future<Either<Failure, AppUserEntity>> call({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    return await _repository
        .signUp(
          email: email,
          password: password,
          username: username,
          avatarUrl: avatarUrl,
        )
        .then(
          (res) => res.mapLeft((l) {
            if (l.code == ErrorCode.conflict) {
              return l.copyWith(AuthErrorMessage.duplicatedEmail.message);
            }
            return l.copyWith('sign up fail');
          }),
        );
  }
}
