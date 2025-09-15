import 'package:sns/domain/entity/chat/dm_conversation.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension DmConversationsWithUserRowExtension on DmConversationsWithUserRow {
  DmConversationEntity toEntity() {
    return DmConversationEntity(
      id: conversationId ?? '',
      otherUserId: otherUserId ?? '',
      otherUsername: otherUsername ?? '',
      updatedAt: lastMessageAt,
      lastMessageId: lastMessageId,
      lastMessageContent: lastMessageContent,
      lastMessageSenderId: lastMessageSenderId,
    );
  }
}
