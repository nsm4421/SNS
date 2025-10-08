import 'package:logger/logger.dart';

import 'package:karma/data/model/model.export.dart';
import 'package:karma/core/core.export.dart';

import 'message/dm_message.datasource.dart';
import 'room/dm_room.datasource.dart';
import 'room_read_state/dm_read_state.datasource.dart';

part 'dm_datasource_impl.dart';

abstract interface class DmDataSource {
  /// room
  Future<Pageable<DmRoomModel>> fetchRooms({
    required String cursor,
    int limit = 30,
  });

  Future<DmRoomModel> createOrGetRoom(String counterpartId);

  /// message
  Future<Pageable<DmMessageModel>> fetchMessages({
    required String roomId,
    required String cursor,
    int limit = 30,
  });

  Future<DmMessageModel> sendTextMessage({
    required String roomId,
    required String content,
  });

  /// read state
  Future<void> markAsRead({
    required String roomId,
    required String lastReadMessageId,
  });
}
