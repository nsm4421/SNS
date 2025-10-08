import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/core/core.export.dart';
import 'package:karma/data/datasource/datasource.export.dart';
import 'package:karma/domain/entity/entity.export.dart';
import 'package:karma/domain/repository/repository.export.dart';

part 'scenario/get_chat_room_channel.usecase.dart';

part 'scenario/get_dm_room.usecase.dart';

part 'scenario/fetch_dm_rooms.usecase.dart';

part 'scenario/fetch_dm_messages.usecase.dart';

part 'scenario/send_text_message.usecase.dart';

part 'scenario/mark_as_read.usecase.dart';

@lazySingleton
class DmUseCases {
  final DmRepository _repository;

  DmUseCases(this._repository);

  GetChatRoomChannelUseCase get chatChannel =>
      GetChatRoomChannelUseCase(_repository);

  GetDmRoomUseCase get createOrGetRoom => GetDmRoomUseCase(_repository);

  FetchDmRoomsUseCase get fetchRooms => FetchDmRoomsUseCase(_repository);

  FetchDmMessagesUseCase get fetchMessages =>
      FetchDmMessagesUseCase(_repository);

  SendTextMessageUseCase get sendTextMessage =>
      SendTextMessageUseCase(_repository);

  MarkAsReadDmUseCase get markAsRead => MarkAsReadDmUseCase(_repository);
}
