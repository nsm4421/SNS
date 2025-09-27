import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/dto/create_chat_room_request.dto.dart';
import 'package:supabase_datasource/src/db/exception/db_error_handler_mixin.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'chat_room_table.datasource_impl.dart';

abstract interface class ChatRoomsTableDatSource {
  Future<ChatRoomsRow> create(CreateChatRoomRequestDto dto);

  Future<Iterable<ChatRoomsRow>> fetchByOwnerId({
    required String ownerId,
    required String cursor, // created_at
    int limit = 30,
  });

  Future<ChatRoomsRow> getById(String id);

  Future<ChatRoomsRow> update({
    required String id,
    String? name,
    bool? isGroup,
    DateTime? lastMessageAt,
  });

  /// 방 삭제
  Future<void> deleteById(String roomId);
}
