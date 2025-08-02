part of '../auth.usecases.dart';

class SignOutUseCase with AppLogger, ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    final signOutRes = await _repository.signOut().thenLeft((l) {
      switch (l.type) {
        case ApiErrorType.unauthorized:
        case ApiErrorType.server:
          return Left(Failure.server('sign out fails'));
        default:
          return Left(handleFailure(l));
      }
    });
    if (signOutRes.isLeft) return signOutRes;

    final clearTokenRes = await _repository.clearTokens();
    if (clearTokenRes.isLeft) {
      logger.w('sign out request success, but removing token fails');
    }

    return const Right(null);
  }
}
