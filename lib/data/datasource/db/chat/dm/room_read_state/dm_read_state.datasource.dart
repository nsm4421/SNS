import 'package:karma/data/datasource/db/generated/database.dart';

part 'dm_read_state.datasource_impl.dart';

abstract interface class DmRoomReadStateDataSource {
  Future<void> updateUnreadCount({
    required String roomId,
    required String currentUserId,
    required String lastReadMessageId,
  });

  Future<DmRoomReadStateRow?> findByRoomIdAndUserId({
    required String roomId,
    required String currentUserId,
  });
}
