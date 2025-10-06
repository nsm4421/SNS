part of 'dm_room.datasource.dart';

class SupabaseDmRoomDataSourceImpl implements DmRoomDataSource {
  final DmRoomsTable _dmRoomsTable;
  final VMyDmRoomsTable _vMyDmRoomsTable;

  SupabaseDmRoomDataSourceImpl({
    required DmRoomsTable dmRoomsTable,
    required VMyDmRoomsTable vMyDmRoomsTable,
  }) : _dmRoomsTable = dmRoomsTable,
       _vMyDmRoomsTable = vMyDmRoomsTable;

  // sortTs : coalesce(last_message_at, created_at)
  String get _cursorColumn => 'sort_ts';

  @override
  Future<Iterable<VMyDmRoomsRow>> fetch({
    required String cursor,
    int limit = 30,
  }) async {
    return _vMyDmRoomsTable.queryRows(
      queryFn: (q) =>
          q.lt(_cursorColumn, cursor).order(_cursorColumn, ascending: false),
      limit: limit,
    );
  }

  @override
  Future<DmRoomsRow> create({
    String? clientRoomId,
    required String currentUserId,
    required String otherUserId,
  }) async {
    final data = (currentUserId.compareTo(otherUserId) < 0)
        ? {'user1_id': currentUserId, 'user2_id': otherUserId}
        : {'user1_id': otherUserId, 'user2_id': currentUserId};
    return _dmRoomsTable.insert({
      if (clientRoomId != null) 'id': clientRoomId,
      ...data,
    });
  }

  @override
  Future<VMyDmRoomsRow?> findById(String roomId) async {
    return _vMyDmRoomsTable.querySingleRow(queryFn: (q) => q.eq('id', roomId));
  }

  @override
  Future<VMyDmRoomsRow?> findByCounterpartId(String counterpartId) async {
    return _vMyDmRoomsTable.querySingleRow(
      queryFn: (q) => q.eq('counterpart_id', counterpartId).limit(1),
    );
  }

  @override
  Future<void> delete(String roomId) async {
    await _dmRoomsTable.delete(
      matchingRows: (q) => q.eq('id', roomId).limit(1),
      returnRows: false,
    );
  }
}
