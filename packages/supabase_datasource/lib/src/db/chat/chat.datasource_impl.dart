part of 'chat.datasource.dart';

class SupabaseChatDataSourceImpl implements ChatDataSource {
  SupabaseChatDataSourceImpl({
    required SupabaseClient client,
    required ChatRoomsTableDatSource chatRoomsTableDatSource,
    required ChatRoomMembersTableDataSource chatRoomMembersTableDataSource,
    required ChatMessagesTableDataSource chatMessagesTableDataSource,
  }) : _chatRoomsTableDatSource = chatRoomsTableDatSource,
       _chatRoomMembersTableDataSource = chatRoomMembersTableDataSource,
       _chatMessagesTableDataSource = chatMessagesTableDataSource {
    _currentUserId = client.auth.currentUser!.id;
  }

  late final String _currentUserId;
  final ChatRoomsTableDatSource _chatRoomsTableDatSource;
  final ChatRoomMembersTableDataSource _chatRoomMembersTableDataSource;
  final ChatMessagesTableDataSource _chatMessagesTableDataSource;

  @override
  Future<ChatRoomModel> createRoom(CreateChatRoomRequestDto dto) async {
    final row = await _chatRoomsTableDatSource.create(dto);
    for (final userId in dto.memberIds) {
      await _chatRoomMembersTableDataSource.create(
        AddMemberRequestDto(
          roomId: row.id,
          userId: userId,
          role: userId == _currentUserId ? 'owner' : 'member',
        ),
      );
    }
    return ChatRoomModel.fromRow(row);
  }

  @override
  Future<void> deleteRoomById(String roomId) async {
    await _chatRoomsTableDatSource.deleteById(roomId);
    await _chatRoomMembersTableDataSource.deleteByRoomId(roomId);
  }

  @override
  Future<ChatRoomModel> getRoomById(String roomId) async {
    return _chatRoomsTableDatSource.getById(roomId).then(ChatRoomModel.fromRow);
  }

  @override
  Future<Pageable<ChatRoomModel>> fetchMyRooms({
    required String cursor,
    int limit = 30,
  }) async {
    return _chatRoomsTableDatSource
        .fetchByOwnerId(ownerId: _currentUserId, cursor: cursor, limit: limit)
        .then((res) => res.map(ChatRoomModel.fromRow))
        .then(
          (res) => Pageable(
            items: res.toList(),
            nextCursor: res.length < limit
                ? null
                : res.lastOrNull?.createdAt.toUtc().toIso8601String(),
          ),
        );
  }

  @override
  Future<ChatRoomModel> updateRoomMeta({
    required String roomId,
    String? name,
    bool isGroup = false,
  }) async {
    if (isGroup && name == null) {
      throw CustomException.database(
        code: ErrorCode.invalidParam,
        message: 'to update group chat, name is necessary',
      );
    }
    return _chatRoomsTableDatSource
        .update(id: roomId, name: name, isGroup: isGroup)
        .then(ChatRoomModel.fromRow);
  }

  @override
  Future<ChatMessageModel> sendMessage(SendMessageRequestDto dto) async {
    final message = await _chatMessagesTableDataSource
        .create(dto)
        .then(ChatMessageModel.fromRow);
    await _chatRoomsTableDatSource.update(
      id: dto.roomId,
      lastMessageAt: message.createdAt,
    );
    return message;
  }

  @override
  Future<Pageable<ChatMessageModel>> fetchMessageByRoomId({
    required String roomId,
    required String cursor,
    int limit = 30,
  }) {
    return _chatMessagesTableDataSource
        .fetchByRoomId(
          roomId: roomId,
          cursor: cursor,
          limit: limit,
        )
        .then((res) => res.map(ChatMessageModel.fromRow))
        .then(
          (res) => Pageable(
            items: res.toList(),
            nextCursor: res.length < limit
                ? null
                : res.lastOrNull?.createdAt.toUtc().toIso8601String(),
          ),
        );
  }
}
