import 'package:karma/data/datasource/db/generated/database.dart';

part 'dm_room.datasource_impl.dart';

abstract interface class DmRoomDataSource {
  /// 내 DM 방 목록
  /// cursor: (sort_ts, room_id) 혹은 (last_message_created_at, last_message_id) 조합을 직렬화해 전달.
  Future<Iterable<VMyDmRoomsRow>> fetch({
    required String cursor,
    int limit = 30,
  });

  /// 방 단건 조회
  Future<VMyDmRoomsRow?> findById(String roomId);

  Future<VMyDmRoomsRow?> findByCounterpartId(String counterpartId);

  /// DM 방 생성(또는 기존 방 재사용).
  Future<DmRoomsRow> create({
    String? clientRoomId,
    required String currentUserId,
    required String otherUserId,
  });

  Future<void> delete(String roomId);
}
