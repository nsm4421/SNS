class DmRoomReadStateModel {
  final String roomId;
  final String userId;
  final String? lastReadMessageId;
  final int unreadCount;

  DmRoomReadStateModel({
    required this.roomId,
    required this.userId,
    this.lastReadMessageId,
    this.unreadCount = 0,
  });
}
