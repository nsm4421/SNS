import 'package:sns/domain/entity/chat/dm_message.entity.dart';
import 'package:supabase_datasource/datasources/database/generated/database.dart';

extension DmMessagesRowExtension on DmMessagesRow {
  DmMessageEntity toEntity() {
    return DmMessageEntity(
      id: conversationId ?? '',
      senderId: senderId,
      content: content ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt
    );
  }
}
