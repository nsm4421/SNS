part of 'dm_datasource.dart';

class SupabaseDmDataSourceImpl implements DmDataSource {
  final DmRoomDataSource _dmRoomDataSource;
  final DmMessageDataSource _dmMessageDataSource;
  final DmRoomReadStateDataSource _dmRoomReadStateDataSource;
  final Logger? _logger;
  final String _currentUserId;

  SupabaseDmDataSourceImpl({
    required DmRoomDataSource dmRoomDataSource,
    required DmMessageDataSource dmMessageDataSource,
    required DmRoomReadStateDataSource dmRoomReadStateDataSource,
    Logger? logger,
    required String currentUserId,
  }) : _dmRoomDataSource = dmRoomDataSource,
       _dmMessageDataSource = dmMessageDataSource,
       _dmRoomReadStateDataSource = dmRoomReadStateDataSource,
       _logger = logger,
       _currentUserId = currentUserId;

  @override
  Future<DmRoomModel> createOrGetRoom(String counterpartId) async {
    final fetched = await _dmRoomDataSource.findByCounterpartId(counterpartId);
    if (fetched != null) {
      return DmRoomModel.fromRow(row: fetched, currentUserId: counterpartId);
    }
    final createdId = await _dmRoomDataSource
        .create(
          currentUserId: _currentUserId,
          otherUserId: counterpartId,
        )
        .then((res) => res.id);
    final created = await _dmRoomDataSource.findById(createdId);
    return DmRoomModel.fromRow(row: created!, currentUserId: counterpartId);
  }

  @override
  Future<Pageable<DmRoomModel>> fetchRooms({
    required String cursor,
    int limit = 30,
  }) async {
    return _dmRoomDataSource
        .fetch(cursor: cursor, limit: limit)
        .then(
          (res) => res
              .map(
                (e) =>
                    DmRoomModel.fromRow(row: e, currentUserId: _currentUserId),
              )
              .toList(),
        )
        .then(Pageable.from);
  }

  @override
  Future<Pageable<DmMessageModel>> fetchMessages({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) async {
    return _dmMessageDataSource
        .fetch(roomId: roomId, cursor: cursor, limit: limit)
        .then(
          (res) => res.map(DmMessageModel.fromRow).toList(),
        )
        .then(Pageable.from);
  }

  @override
  Future<DmMessageModel> sendTextMessage({
    String? clientMessageId,
    required String roomId,
    required String content,
  }) async {
    final messageId = await _dmMessageDataSource
        .create(
          clientMessageId: clientMessageId,
          roomId: roomId,
          senderId: _currentUserId,
          content: content,
        )
        .then((res) => res.id);
    final fetched = await _dmMessageDataSource.findById(messageId);
    if (fetched == null) {
      throw CustomException.database(
        message: 'created message not found',
        code: ErrorCode.notFound,
      );
    }
    return DmMessageModel.fromRow(fetched);
  }

  @override
  Future<void> markAsRead({
    required String roomId,
    required String lastReadMessageId,
  }) async {
    await _dmRoomReadStateDataSource.updateUnreadCount(
      roomId: roomId,
      currentUserId: _currentUserId,
      lastReadMessageId: lastReadMessageId,
    );
  }
}
