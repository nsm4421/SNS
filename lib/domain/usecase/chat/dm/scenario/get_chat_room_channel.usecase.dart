part of '../dm.usecases.dart';

final class GetChatRoomChannelUseCase {
  final DmRepository _repository;

  GetChatRoomChannelUseCase(this._repository);

  Either<Failure, ChatRoomChannel> call(String roomId) {
    return _repository.getChatRoomChannel(roomId);
  }
}
