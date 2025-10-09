part of '../user.usecases.dart';

final class GetIsUsernameDuplicatedUseCase {
  final UserRepository _repository;

  GetIsUsernameDuplicatedUseCase(this._repository);

  Future<Either<Failure, bool>> call(String username) async {
    return await _repository.getIsUsernameDuplicated(username);
  }
}
