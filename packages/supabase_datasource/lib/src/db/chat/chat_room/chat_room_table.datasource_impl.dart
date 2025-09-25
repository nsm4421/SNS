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
  Future<Pageable<ChatRoomsRow>> findByOwnerId({
    required String ownerId,
    String? cursor,
    int limit = 30,
  }) async {
    try {
      return await _chatRoomsTable
          .queryRows(
            queryFn: (q) => q
                .eq('owner_id', ownerId)
                .order('created_at', ascending: false)
                .order('id', ascending: false)
                .limit(limit),
          )
          .then(
            (res) => Pageable(
              items: res,
              nextCursor: (res.length < limit || res.isEmpty)
                  ? null
                  : res.first.createdAt.toUtc().toIso8601String(),
            ),
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
          code: 'NOT_FOUND',
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
  Future<ChatRoomsRow> updateMeta({
    required String roomId,
    String? name,
    bool? isGroup,
  }) async {
    try {
      final updated = await _chatRoomsTable.update(
        matchingRows: (q) => q.eq('id', roomId),
        data: {
          if (name != null) 'name': name,
          if (isGroup != null) 'is_group': isGroup,
        },
      ).then((res)=>res.firstOrNull);
      if (updated == null){
        throw CustomException.database(
          message: 'nothing updated',
          code: 'NOT_FOUND',
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
