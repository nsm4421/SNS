import 'package:supabase_datasource/src/models/supabase/database.dart';

class ChatMessageModel extends ChatMessagesRow {
  ChatMessageModel({
    required super.id,
    required super.roomId,
    required super.senderId,
    super.content = '',
    super.msgType = 'text',
    required super.createdAt,
    super.editedAt,
    super.deletedAt,
  });

  static ChatMessageModel fromRow(ChatMessagesRow row) {
    return ChatMessageModel(
      id: row.id,
      roomId: row.roomId,
      senderId: row.senderId,
      content: row.content,
      msgType: row.msgType,
      createdAt: row.createdAt,
      editedAt: row.editedAt,
      deletedAt: row.deletedAt,
    );
  }
}
