part of '../auth.usecases.dart';

class RestoreSessionUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  RestoreSessionUseCase(this._repository);

  Future<Either<Failure, void>> call() async {
    final getRefreshTokenRes = await _repository.getRefreshToken().thenLeft(
      (l) => Left(Failure.unAuthorized('un authorized')),
    );
    if (getRefreshTokenRes.isLeft) return getRefreshTokenRes;

    final restoreSessionRes = await _repository
        .getNewTokens(getRefreshTokenRes.right)
        .thenLeft((l) => Left(Failure.unAuthorized('un authorized')));
    if (restoreSessionRes.isLeft) return restoreSessionRes;

    final saveTokenRes = await _repository
        .saveTokens(
          accessToken: restoreSessionRes.right.$1,
          refreshToken: restoreSessionRes.right.$2,
        )
        .thenLeft((l) => Left(Failure.unAuthorized('un authorized')));
    if (saveTokenRes.isLeft) return saveTokenRes;

    return const Right(null);
  }
}
