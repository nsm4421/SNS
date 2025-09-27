import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/dto/create_chat_room_request.dto.dart';
import 'package:supabase_datasource/src/db/chat/dto/edit_message_request.dto.dart';
import 'package:supabase_datasource/src/db/chat/dto/send_message_request.dto.dart';
import 'package:supabase_datasource/src/db/exception/db_error_handler_mixin.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'chat_messages_table.datasource_impl.dart';

abstract interface class ChatMessagesTableDataSource {
  Future<ChatMessagesRow> create(SendMessageRequestDto dto);

  Future<Iterable<ChatMessagesRow>> fetchByRoomId({
    required String roomId,
    required String cursor,
    int limit = 30,
  });

  Future<ChatMessagesRow> getById(String messageId);

  Future<ChatMessagesRow> update(EditMessageRequestDto dto);

  Future<void> softDeleteById(String messageId);
}
