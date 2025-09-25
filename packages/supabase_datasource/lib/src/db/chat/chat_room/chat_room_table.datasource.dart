import 'package:shared/shared.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_datasource/src/db/chat/dto/create_chat_room_request.dto.dart';
import 'package:supabase_datasource/src/db/exception/db_error_handler_mixin.dart';
import 'package:supabase_datasource/src/models/supabase/database.dart';

part 'chat_room_table.datasource_impl.dart';

abstract interface class ChatRoomsTableDatSource {
  Future<ChatRoomsRow> create(CreateChatRoomRequestDto dto);

  Future<Pageable<ChatRoomsRow>> findByOwnerId({
    required String ownerId,
    String? cursor,
    int limit = 30,
  });

  Future<ChatRoomsRow> getById(String id);

  /// 방 메타 업데이트 (예: 이름 변경)
  Future<ChatRoomsRow> updateMeta({
    required String roomId,
    String? name,
    bool? isGroup,
  });

  /// 방 삭제
  Future<void> deleteById(String roomId);
}
