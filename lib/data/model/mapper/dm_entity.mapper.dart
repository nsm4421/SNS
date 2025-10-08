import 'package:karma/data/model/dm/dm_message.model.dart';
import 'package:karma/data/model/dm/dm_room.model.dart';
import 'package:karma/data/model/mapper/user_entity.mapper.dart';
import 'package:karma/domain/entity/chat/dm_message.entity.dart';
import 'package:karma/domain/entity/chat/dm_room.entity.dart';
import 'package:karma/domain/entity/chat/dm_room_read_state.dart';

import '../dm/dm_room_read_state.model.dart';

extension DmRoomMapper on DmRoomModel {
  DmRoomEntity toEntity() {
    return DmRoomEntity(
      roomId: roomId,
      counterpart: counterpart.toEntity(),
      readState: readState.toEntity(),
      lastMessage: lastMessage?.toEntity(),
      sortTs: sortTs,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

extension DmMessageMapper on DmMessageModel {
  DmMessageEntity toEntity() {
    return DmMessageEntity(
      id: id,
      roomId: roomId,
      senderId: senderId,
      content: content,
      msgType: msgType.name,
      metadata: metadata,
      createdAt: createdAt,
      deletedAt: deletedAt,
    );
  }
}

extension DmRoomReadStateMapper on DmRoomReadStateModel {
  DmRoomReadStateEntity toEntity() {
    return DmRoomReadStateEntity(
      roomId: roomId,
      lastReadMessageId: lastReadMessageId,
      unreadCount: unreadCount,
    );
  }
}
