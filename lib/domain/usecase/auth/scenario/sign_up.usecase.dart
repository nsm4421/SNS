part of '../auth.usecases.dart';

final class SignUpUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignUpUseCase(this._authRepository, this._userRepository);

  Future<Either<Failure, AppUserEntity>> call({
    required String email,
    required String password,
    String? username,
    String? avatarUrl,
  }) async {
    return await _authRepository
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
        )
        .whenComplete(() async {
          await _userRepository
              .updateLastSeenAt(DateTime.now())
              .then(
                (res) => res.mapLeft((l) {
                  debugPrint('update last seen at failed');
                }),
              );
        });
    ;
  }
}
