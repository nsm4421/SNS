import 'dart:async';

import 'package:shared/pagination/page.dart';
import 'package:shared/response_wrapper/api_response/api_exception.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

part 'dm_conversation.datasource.dart';

class DmConversationDataSourceImpl implements DmConversationDataSource {
  DmConversationDataSourceImpl({
    required DmConversationsTable dmConversationsTable,
    required DmConversationsWithUserTable dmConversationsWithUserTable,
  }) : _dmConversationsTable = dmConversationsTable,
       _dmConversationsWithUserTable = dmConversationsWithUserTable;

  final DmConversationsTable _dmConversationsTable;
  final DmConversationsWithUserTable _dmConversationsWithUserTable;

  @override
  Future<Page<DmConversationsWithUserRow>> fetchConversations({
    String? cursor,
    int limit = 30,
  }) async {
    return _dmConversationsWithUserTable
        .queryRows(
          queryFn: (q) => q
              .lt('last_message_created_at', cursor ?? DateTime.now().toUtc())
              .order('last_message_created_at'),
          limit: limit,
        )
        .then((res) {
          return Page(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.lastMessageCreatedAt!.toUtc().toString(),
          );
        });
  }

  @override
  Future<DmConversationsRow> getOrCreateConversation(
    String otherUserId,
  ) async {
    DmConversationsRow? response;
    response = await _dmConversationsTable.querySingleRow(
      queryFn: (q) => q.or('user1_id=$otherUserId,user2_id=$otherUserId'),
    );
    response ??= await _dmConversationsTable.insertRow(
      DmConversationsRow(user2Id: otherUserId),
    );
    return response;
  }

  @override
  Future<DmConversationsRow> updateLastSeenAt({
    required String conversationId,
    required String userId,
    DateTime? lastSeenAt,
  }) async {
    final conversation = await _dmConversationsTable.querySingleRow(
      queryFn: (q) => q.eq('id', conversationId),
    );
    if (conversation == null) {
      throw ApiException.notFound('conversation not found');
    }
    return _dmConversationsTable.upsertRow(
      userId == conversation.user1Id
          ? conversation.copyWith(user1LastSeenAt: lastSeenAt)
          : conversation.copyWith(user2LastSeenAt: lastSeenAt),
    );
  }
}
