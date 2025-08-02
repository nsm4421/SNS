part of '../auth.usecases.dart';

class FindUserByUidUseCase with ApiErrorToFailureMapperMixIn {
  final AuthRepository _repository;

  FindUserByUidUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String uid) async {
    return await _repository.findByUid(uid).thenLeft((l) {
      if (l.type == ApiErrorType.notFound) {
        return Left(Failure('user not found'));
      }
      return Left(handleFailure(l));
    });
  }
}
