part of '../dm.usecases.dart';

final class FetchDmRoomsUseCase {
  final DmRepository _repository;

  FetchDmRoomsUseCase(this._repository);

  Future<Either<Failure, Pageable<DmRoomEntity>>> call({
    required String cursor, // sort_ts
    int limit = 30,
  }) async {
    return await _repository.fetchRooms(cursor: cursor, limit: limit);
  }
}
