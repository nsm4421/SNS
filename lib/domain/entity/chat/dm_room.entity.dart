import 'package:copy_with_extension/copy_with_extension.dart';

import 'package:karma/domain/entity/auth/user.entity.dart';
import 'package:karma/domain/entity/chat/dm_message.entity.dart';
import 'package:karma/domain/entity/chat/dm_room_read_state.dart';

part 'dm_room.entity.g.dart';

@CopyWith(copyWithNull: true)
class DmRoomEntity {
  final String roomId;
  final UserEntity counterpart;
  final DmRoomReadStateEntity readState;
  final DmMessageEntity? lastMessage;
  final DateTime sortTs;
  final DateTime createdAt;
  final DateTime updatedAt;

  DmRoomEntity({
    required this.roomId,
    required this.counterpart,
    required this.readState,
    required this.lastMessage,
    required this.sortTs,
    required this.createdAt,
    required this.updatedAt,
  });
}
