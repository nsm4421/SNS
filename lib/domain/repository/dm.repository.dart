import 'package:either_dart/either.dart';
import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_error.dart';
import 'package:shared/response_wrapper/stream/stream_payload_wrapper.dart';
import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';

import 'package:sns/domain/entity/chat/dm_message.entity.dart';

abstract interface class DmRepository {
  Stream<StreamPayloadWrapper<DmConversationEntity>> getConversationStream();

  Stream<StreamPayloadWrapper<DmMessageEntity>> getMessageStream( String conversationId);

  Future<Either<ApiError, String>> getConversationByOtherUid(String otherUid);

  Future<Either<ApiError, Page<DmConversationEntity>>> fetchConversations({
    required String cursor,
    int limit = 20,
  });

  Future<Either<ApiError, void>> updateConversationLastSeenAt(
    String conversationId, {
    DateTime? lastSeenAt,
  });

  Future<Either<ApiError, void>> deleteConversation(String conversationId);

  Future<Either<ApiError, DmMessageEntity>> createMessage({
    required String conversationId,
    required String content,
  });

  Future<Either<ApiError, Page<DmMessageEntity>>> fetchMessages({
    required conversationId,
    required String cursor,
    int limit = 20,
  });

  Future<Either<ApiError, void>> deleteMessage(String messageId);
}
