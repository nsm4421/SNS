import 'package:supabase_datasource/src/models/chat/dm_message.model.dart';
import 'package:supabase_datasource/src/models/chat/dm_room_read_state.model.dart';
import 'package:supabase_datasource/src/models/profile/profile.model.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

class DmRoomModel {
  final String roomId;
  final ProfileModel counterpart;
  final DmRoomReadStateModel readState;
  final DmMessageModel? lastMessage;
  final DateTime sortTs;
  final DateTime createdAt;
  final DateTime updatedAt;

  DmRoomModel({
    required this.roomId,
    required this.counterpart,
    required this.readState,
    this.lastMessage,
    required this.sortTs,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DmRoomModel.fromRow({
    required VMyDmRoomsRow row,
    required String currentUserId,
  }) {
    return DmRoomModel(
      roomId: row.roomId ?? '',
      counterpart: ProfileModel(
        userId: row.counterpartId ?? '',
        username: row.counterpartUsername ?? '',
        avatarUrl: row.counterpartAvatarUrl ?? '',
      ),
      readState: DmRoomReadStateModel(
        roomId: row.lastReadMessageId ?? '',
        userId: currentUserId,
        lastReadMessageId: row.lastReadMessageId,
        unreadCount: row.unreadCount ?? 0,
      ),
      lastMessage: row.lastMessageId == null
          ? null
          : DmMessageModel(
              id: row.lastMessageId ?? '',
              roomId: row.roomId ?? '',
              senderId: row.lastMessageSenderId ?? '',
              content: row.lastMessageContent ?? '',
              createdAt: row.lastMessageCreatedAt!,
            ),
      sortTs: row.sortTs!,
      createdAt: row.createdAt!,
      updatedAt: row.updatedAt!,
    );
  }
}
