import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:karma/domain/entity/chat/chat_room.entity.dart';
import 'package:karma/domain/repository/chat.repository.dart';
import 'package:shared/shared.dart';

part 'scenario/fetch_chat_room.usecase.dart';

@lazySingleton
class ChatUseCases {
  final ChatRepository _repository;

  ChatUseCases(this._repository);
}
