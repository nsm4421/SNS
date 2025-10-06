import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'dm_message.datasource_impl.dart';

abstract interface class DmMessageDataSource {
  Future<Iterable<VMyDmMessagesRow>> fetch({
    required String roomId,
    required String cursor,
    int limit = 30,
  });

  Future<VMyDmMessagesRow?> findById(String messageId);

  Future<DmMessagesRow> create({
    String? clientMessageId,
    required String roomId,
    required String senderId,
    required String content,
    MessageType msgType = MessageType.text,
    Map<String, dynamic>? metadata,
  });

  Future<void> softDelete(String messageId);
}
