part of 'dm_message.datasource.dart';

class SupabaseDmMessageDataSourceImpl implements DmMessageDataSource {
  final DmMessagesTable _dmMessagesTable;
  final VMyDmMessagesTable _vMyDmMessagesTable;

  SupabaseDmMessageDataSourceImpl({
    required DmMessagesTable dmMessagesTable,
    required VMyDmMessagesTable vMyDmMessagesTable,
  }) : _dmMessagesTable = dmMessagesTable,
       _vMyDmMessagesTable = vMyDmMessagesTable;

  String get _cursorColumn => 'created_at';

  @override
  Future<Iterable<VMyDmMessagesRow>> fetch({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) async {
    return _vMyDmMessagesTable.queryRows(
      queryFn: (q) => q
          .eq('room_id', roomId)
          .lt(_cursorColumn, cursor)
          .order(_cursorColumn, ascending: false),
      limit: limit,
    );
  }

  @override
  Future<VMyDmMessagesRow?> findById(String messageId) async {
    return _vMyDmMessagesTable.querySingleRow(
      queryFn: (q) => q.eq('id', messageId),
    );
  }

  @override
  Future<DmMessagesRow> create({
    String? clientMessageId,
    required String roomId,
    required String senderId,
    required String content,
    MessageType msgType = MessageType.text,
    Map<String, dynamic>? metadata,
  }) async {
    final data = {
      // optimistic update 시에는 직접 room id를 전달
      if (clientMessageId != null) 'id': clientMessageId,
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'msg_type': msgType.name,
      if (metadata != null) 'metadata': metadata,
    };
    return _dmMessagesTable.insert(data);
  }

  @override
  Future<void> softDelete(String messageId) async {
    await _dmMessagesTable.update(
      matchingRows: (q) => q.eq('id', messageId).limit(1),
      data: {
        'updated_at': DateTime.now().toUtc().toIso8601String(),
        'content': null,
        'metadata': null,
      },
      returnRows: false,
    );
  }
}
