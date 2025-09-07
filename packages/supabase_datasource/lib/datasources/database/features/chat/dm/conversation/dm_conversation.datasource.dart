part of 'dm_conversation.datasource_impl.dart';

abstract interface class DmConversationDataSource {
  Future<DmConversationsRow> getOrCreateConversation(String otherUserId);

  Future<Page<DmConversationsWithUserRow>> fetchConversations({
    String? cursor,
    int limit = 20,
  });

  Future<DmConversationsRow> updateLastSeenAt({
    required String conversationId,
    required String userId,
    DateTime? lastSeenAt,
  });
}
