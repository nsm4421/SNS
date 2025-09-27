part of 'chat_room_member_table.datasource.dart';

class SupabaseChatRoomMembersTableDataSourceImpl
    with DbErrorHandlerMixin
    implements ChatRoomMembersTableDataSource {
  SupabaseChatRoomMembersTableDataSourceImpl(this._chatRoomMembersTable);

  final ChatRoomMembersTable _chatRoomMembersTable;

  @override
  Future<ChatRoomMembersRow> create(AddMemberRequestDto dto) async {
    try {
      return await _chatRoomMembersTable.insert(dto.toJson());
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ChatRoomMembersRow>> findByRoomId(String roomId) async {
    try {
      return await _chatRoomMembersTable.queryRows(
        queryFn: (q) => q.eq('room_id', roomId),
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteByRoomId(String roomId) async {
    try {
      await _chatRoomMembersTable.delete(
        matchingRows: (q) => q.eq('room_id', roomId),
      );
    } on PostgrestException catch (e) {
      throwCustomExceptionFromPostgresException(e);
    } catch (e) {
      rethrow;
    }
  }
}
