part of '../auth.usecases.dart';

final class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, AppUserEntity>> call() async {
    return await _repository.getCurrentUser().then(
      (res) => res.mapLeft((l) {
        if (l.code == ErrorCode.notFound) {
          return l.copyWith(AuthErrorMessage.gettingCurrentUserFail.message);
        }
        return l.copyWith('unknown auth error occurs');
      }),
    );
  }
}
