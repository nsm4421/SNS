import 'package:shared/pagination/page.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

part 'dm_message.datasource.dart';

class DmMessageDataSourceImpl implements DmMessageDataSource {
  DmMessageDataSourceImpl(this._dmMessagesTable);

  final DmMessagesTable _dmMessagesTable;

  @override
  Future<void> deleteDirectMessageById(String messageId) async {
    await _dmMessagesTable.delete(
      matchingRows: (q) => q.eq('id', messageId),
      returnRows: false,
    );
  }

  @override
  Future<Page<DmMessagesRow>> fetchDirectMessages({
    required String conversationId,
    String? cursor,
    int limit = 20,
  }) async {
    return _dmMessagesTable
        .queryRows(
          queryFn: (q) => q
              .eq('conversation_id', conversationId)
              .lt('created_at', cursor ?? DateTime.now().toUtc())
              .order('created_at'),
          limit: limit,
        )
        .then((res) {
          return Page(
            items: res,
            nextCursor: res.length < limit
                ? null
                : res.first.createdAt!.toUtc().toString(),
          );
        });
  }

  @override
  Future<DmMessagesRow> createDirectMessage({
    required String conversationId,
    required String content,
    Map<String, dynamic>? metadata,
  }) async {
    return _dmMessagesTable.insertRow(
      DmMessagesRow(
        conversationId: conversationId,
        content: content,
        metadata: metadata,
      ),
    );
  }
}
