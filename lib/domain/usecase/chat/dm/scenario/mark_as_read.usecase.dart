part of '../dm.usecases.dart';

final class MarkAsReadDmUseCase {
  final DmRepository _repository;

  MarkAsReadDmUseCase(this._repository);

  Future<Either<Failure, Unit>> call({
    required String roomId,
    required String lastReadMessageId,
  }) async {
    return await _repository.markAsRead(
      roomId: roomId,
      lastReadMessageId: lastReadMessageId,
    );
  }
}
