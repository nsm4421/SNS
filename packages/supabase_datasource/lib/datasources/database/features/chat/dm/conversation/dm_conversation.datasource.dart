part of 'dm_conversation.datasource_impl.dart';

abstract interface class DmConversationDataSource {
  Future<DmConversationsWithUserRow?> findConversationWithUserById(
    String conversationId,
  );

  Future<DmConversationsRow> getOrCreateConversation(String otherUserId);

  Future<Page<DmConversationsWithUserRow>> fetchConversations({
    String? cursor,
    int limit = 20,
  });

  Future<void> updateLastSeenAt({
    required String conversationId,
    required String userId,
    required DateTime lastSeenAt,
  });

  Future<void> deleteConversationById(String conversationId);
}
