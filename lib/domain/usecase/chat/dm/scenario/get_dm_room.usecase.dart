part of '../dm.usecases.dart';

final class GetDmRoomUseCase {
  final DmRepository _repository;

  GetDmRoomUseCase(this._repository);

  Future<Either<Failure, DmRoomEntity>> call(String counterpartId) async {
    return await _repository.createOrGetRoom(counterpartId);
  }
}
