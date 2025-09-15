import 'package:injectable/injectable.dart';
import 'package:shared/response_wrapper/stream/stream_payload_wrapper.dart';
import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';
import 'package:sns/domain/entity/chat/dm_message.entity.dart';
import 'package:sns/domain/repository/dm.repository.dart';

import 'scenario/dm/delete_message.usecase.dart';
import 'scenario/dm/fetch_conversations.usecase.dart';
import 'scenario/dm/fetch_messages.usecase.dart';
import 'scenario/dm/send_message.usecase.dart';
import 'scenario/dm/get_conversation.usecase.dart';
import 'scenario/dm/update_conversation_last_seen_at.usecase.dart';

@lazySingleton
class DmUseCases {
  DmUseCases(this._dmRepository);

  final DmRepository _dmRepository;

  Stream<StreamPayloadWrapper<DmConversationEntity>> Function()
  get getConversationStreamCallback => _dmRepository.getConversationStream;

  Stream<StreamPayloadWrapper<DmMessageEntity>> Function(String conversationId)
  get getMessageStreamCallback =>
      (String conversationId) => _dmRepository.getMessageStream(conversationId);

  GetDmConversationUseCase get getConversation =>
      GetDmConversationUseCase(_dmRepository);

  FetchDmConversationsUseCase get fetchConversations =>
      FetchDmConversationsUseCase(_dmRepository);

  SendDmMessageUseCase get sendMessage => SendDmMessageUseCase(_dmRepository);

  FetchDmMessagesUseCase get fetchMessages =>
      FetchDmMessagesUseCase(_dmRepository);

  DeleteMessageUseCase get deleteMessage => DeleteMessageUseCase(_dmRepository);

  UpdateDmConversationLastSeenAtUseCase get updateLastSeenAt =>
      UpdateDmConversationLastSeenAtUseCase(_dmRepository);
}
