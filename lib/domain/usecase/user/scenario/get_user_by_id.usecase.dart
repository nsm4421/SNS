part of '../user.usecases.dart';

final class GetUserByIdUseCase {
  final UserRepository _repository;

  GetUserByIdUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call(String userId) async {
    return await _repository.getById(userId);
  }
}
