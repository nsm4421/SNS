part of 'chat.datasource.dart';

class SupabaseChatDataSourceImpl implements ChatDataSource {
  SupabaseChatDataSourceImpl({
    required SupabaseClient client,
    required ChatRoomsTableDatSource chatRoomsTableDatSource,
    required ChatRoomMembersTableDataSource chatRoomMembersTableDataSource,
  }) : _chatRoomsTableDatSource = chatRoomsTableDatSource,
       _chatRoomMembersTableDataSource = chatRoomMembersTableDataSource {
    _currentUserId = client.auth.currentUser!.id;
  }

  late final String _currentUserId;
  final ChatRoomsTableDatSource _chatRoomsTableDatSource;
  final ChatRoomMembersTableDataSource _chatRoomMembersTableDataSource;

  @override
  Future<ChatRoomModel> createChatRoom(CreateChatRoomRequestDto dto) async {
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
  Future<void> deleteChatRoomById(String roomId) async {
    await _chatRoomsTableDatSource.deleteById(roomId);
    await _chatRoomMembersTableDataSource.deleteByRoomId(roomId);
  }

  @override
  Future<ChatRoomModel> getChatRoomById(String roomId) async {
    final chatRoomRow = await _chatRoomsTableDatSource.getById(roomId);
    return ChatRoomModel.fromRow(
      chatRoomRow,
    );
  }

  @override
  Future<Pageable<ChatRoomModel>> getMyChatRooms({
    String? cursor,
    int limit = 30,
  }) async {
    return _chatRoomsTableDatSource
        .findByOwnerId(ownerId: _currentUserId, cursor: cursor, limit: limit)
        .then((res) => res.convert(ChatRoomModel.fromRow));
  }

  @override
  Future<ChatRoomModel> updateChatRoomMeta({
    required String roomId,
    String? name,
    bool? isGroup,
  }) async {
    return await _chatRoomsTableDatSource
        .updateMeta(roomId: roomId, name: name, isGroup: isGroup)
        .then(ChatRoomModel.fromRow);
  }
}
