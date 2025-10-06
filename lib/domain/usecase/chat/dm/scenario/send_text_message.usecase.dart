part of '../dm.usecases.dart';

final class SendTextMessageUseCase {
  final DmRepository _repository;

  SendTextMessageUseCase(this._repository);

  Future<Either<Failure, DmMessageEntity>> call({
    required String roomId,
    required String content,
  }) async {
    return await _repository.sendTextMessage(roomId: roomId, content: content);
  }
}
