part of 'dm_message.datasource_impl.dart';

abstract interface class DmMessageDataSource {
  Future<Page<DmMessagesRow>> fetchDirectMessages({
    required String conversationId,
    String? cursor,
    int limit = 20,
  });

  Future<DmMessagesRow> createDirectMessage({
    required String conversationId,
    required String content,
    Map<String, dynamic>? metadata,
  });

  Future<void> deleteDirectMessageById(String messageId);
}
