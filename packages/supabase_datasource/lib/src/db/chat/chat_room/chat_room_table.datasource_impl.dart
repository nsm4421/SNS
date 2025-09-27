part of 'chat_room_table.datasource.dart';

class SupabaseChatRoomsTableDataSourceImpl
    with DbErrorHandlerMixin
    implements ChatRoomsTableDatSource {
  SupabaseChatRoomsTableDataSourceImpl(this._chatRoomsTable);

  final ChatRoomsTable _chatRoomsTable;

  @override
  Future<ChatRoomsRow> create(CreateChatRoomRequestDto dto) async {
    try {
      return await _chatRoomsTable.insert(dto.toJson());
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteById(String roomId) async {
    try {
      await _chatRoomsTable.delete(
        matchingRows: (q) => q.eq('room_id', roomId),
        returnRows: false,
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatRoomsRow>> fetchByOwnerId({
    required String ownerId,
    required String cursor,
    int limit = 30,
  }) async {
    try {
      return await _chatRoomsTable.queryRows(
        queryFn: (q) => q
            .eq('owner_id', ownerId)
            .lt('created_at', cursor)
            .order('created_at', ascending: false)
            .order('id', ascending: false)
            .limit(limit),
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ChatRoomsRow> getById(String id) async {
    try {
      final fetched = await _chatRoomsTable.querySingleRow(
        queryFn: (q) => q.eq('id', id),
      );
      if (fetched == null) {
        throw CustomException.database(
          message: 'room id $id is not founded',
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
  Future<ChatRoomsRow> update({
    required String id,
    String? name,
    bool? isGroup,
    DateTime? lastMessageAt,
  }) async {
    try {
      final updated = await _chatRoomsTable
          .update(
            matchingRows: (q) => q.eq('id', id),
            data: {
              if (name != null) 'name': name,
              if (isGroup != null) 'is_group': isGroup,
              if (lastMessageAt != null)
                'last_message_at': lastMessageAt.toUtc().toIso8601String(),
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
}
