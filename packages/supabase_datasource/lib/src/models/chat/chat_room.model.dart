import 'package:supabase_datasource/src/models/supabase/database.dart';

class ChatRoomModel extends ChatRoomsRow {
  ChatRoomModel({
    required super.id,
    super.isGroup = false,
    super.name,
    super.lastMessageAt,
    required super.createdAt,
    required super.updatedAt,
  });

  static ChatRoomModel fromRow(ChatRoomsRow row) {
    return ChatRoomModel(
      id: row.id,
      isGroup: row.isGroup,
      name: row.name,
      lastMessageAt: row.lastMessageAt,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
