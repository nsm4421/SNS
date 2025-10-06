part of '../dm.usecases.dart';

final class FetchDmMessagesUseCase {
  final DmRepository _repository;

  FetchDmMessagesUseCase(this._repository);

  Future<Either<Failure, Pageable<DmMessageEntity>>> call({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) {
    return _repository.fetchMessages(
      roomId: roomId,
      cursor: cursor,
      limit: limit,
    );
  }
}
