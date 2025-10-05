part of 'chat_messages_table.datasource.dart';

class SupabaseChatMessagesTableDataSourceImpl
    with DbErrorHandlerMixin
    implements ChatMessagesTableDataSource {
  SupabaseChatMessagesTableDataSourceImpl(this._chatMessagesTable);

  final ChatMessagesTable _chatMessagesTable;

  @override
  Future<ChatMessagesRow> create(SendMessageRequestDto dto) async {
    try {
      return await _chatMessagesTable.insert({
        ...dto.toJson(),
        // optimistic update를 위해 직접 message id를 전달하는 경우
        if (dto.messageId !=null) 'id':dto.messageId
      });
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatMessagesRow> update(EditMessageRequestDto dto) async {
    try {
      final updated = await _chatMessagesTable
          .update(
            matchingRows: (q) => q.eq(
              'id',
              dto.messageId,
            ),
            data: {
              ...dto.toJson(),
              'edited_at': DateTime.now().toUtc().toIso8601String(),
            },
          )
          .then((res) => res.firstOrNull);
      if (updated == null) {
        throw CustomException.database(
          message: 'nothing updated',
          code: ErrorCode.notFound,
        );
      }
      return updated;
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatMessagesRow> getById(String messageId) async {
    try {
      final fetched = await _chatMessagesTable.querySingleRow(
        queryFn: (q) => q.eq('id', messageId),
      );
      if (fetched == null) {
        throw CustomException.database(
          message: 'message id $messageId not found',
          code: ErrorCode.notFound,
        );
      }
      return fetched;
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatMessagesRow>> fetchByRoomId({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) async {
    try {
      return await _chatMessagesTable.queryRows(
        queryFn: (q) => q
            .eq('room_id', roomId)
            .lt('created_at', cursor)
            .order('created_at', ascending: false)
            .order('id')
            .limit(limit),
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> softDeleteById(String messageId) async {
    try {
      await _chatMessagesTable.update(
        matchingRows: (q) => q.eq('id', messageId),
        data: {'deleted_at': DateTime.now().toUtc().toIso8601String()},
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }
}
