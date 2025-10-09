part of '../auth.usecases.dart';

final class SignInUseCase {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  SignInUseCase(this._authRepository, this._userRepository);

  Future<Either<Failure, AppUserEntity>> call({
    required String email,
    required String password,
  }) async {
    return await _authRepository
        .signIn(email: email, password: password)
        .then(
          (res) => res.mapLeft((l) {
            if (l.code == ErrorCode.invalidCredential) {
              return l.copyWith(AuthErrorMessage.invalidCredentials.message);
            }
            return l.copyWith('sign in fail');
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
  }
}
