import 'package:copy_with_extension/copy_with_extension.dart';

part 'dm_room_read_state.g.dart';

@CopyWith(copyWithNull: true)
class DmRoomReadStateEntity {
  final String roomId;
  final String? lastReadMessageId;
  final int unreadCount;

  DmRoomReadStateEntity({
    required this.roomId,
    this.lastReadMessageId,
    this.unreadCount = 0,
  });
}
