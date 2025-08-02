part of '../auth.usecases.dart';

class GetCurrentUserUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.getCurrentUser().thenLeft((l) {
      return Left(() {
        switch (l.type) {
          case ApiErrorType.unauthorized:
          case ApiErrorType.notFound:
            return Failure.unAuthorized();
          default:
            return handleFailure(l);
        }
      }());
    });
  }
}
