part of 'dm_read_state.datasource.dart';

class SupabaseDmRoomReadStateDataSourceImpl implements DmRoomReadStateDataSource {
  final DmRoomReadStateTable _dmRoomReadStateTable;

  SupabaseDmRoomReadStateDataSourceImpl(this._dmRoomReadStateTable);

  @override
  Future<void> updateUnreadCount({
    required String roomId,
    required String currentUserId,
    required String lastReadMessageId,
  }) async {
    await _dmRoomReadStateTable.update(
      matchingRows: (q) => q
          .eq('room_id', roomId)
          .eq('user_id', currentUserId)
          .eq('last_read_message_id', lastReadMessageId)
          .limit(1),
      data: {
        'unread_count': 0,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      },
      returnRows: false,
    );
  }

  @override
  Future<DmRoomReadStateRow?> findByRoomIdAndUserId({
    required String roomId,
    required String currentUserId,
  }) async {
    return _dmRoomReadStateTable.querySingleRow(
      queryFn: (q) =>
          q.eq('room_id', roomId).eq('user_id', currentUserId).limit(1),
    );
  }
}
